# Firebase デプロイ完全ガイド

## 概要

このガイドでは、Nx モノレポで構築された Angular フロントエンドと Rust バックエンドを Firebase にデプロイする手順を解説します。

### プロジェクト構成

- **フロントエンド**: Angular 19.2.9 (Firebase Hosting)
- **バックエンド**: Rust + Actix-web (Firebase Functions)
- **モノレポ管理**: Nx 21.1.3
- **CI/CD**: GitHub Actions + Nx Cloud

## 前提条件

### 必要なツール

- Node.js 20.x
- Rust (latest stable)
- Firebase CLI
- Git

### Firebase プロジェクトの作成

1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. 新しいプロジェクトを作成
3. プロジェクト ID をメモ（例: `completely-understood-vol61`）

## 実装手順

### 1. Firebase CLI のセットアップ

```bash
# Firebase CLI のインストール
npm install -g firebase-tools

# Firebase にログイン
firebase login

# プロジェクトの初期化
firebase init

# 選択項目:
# - Hosting: Configure files for Firebase Hosting
# - Functions: Configure a Cloud Functions directory and its files
# - Use an existing project: 作成したプロジェクトを選択
# - Public directory: dist/apps/frontend/browser
# - Configure as a single-page app: Yes
# - Set up automatic builds and deploys with GitHub: Yes
```

### 2. 設定ファイルの作成

#### `firebase.json` の作成

```bash
# プロジェクトルートに firebase.json を作成
cat > firebase.json << 'EOF'
{
  "hosting": {
    "public": "dist/apps/frontend/browser",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  },
  "functions": {
    "source": "apps/backend",
    "runtime": "nodejs20"
  }
}
EOF
```

#### `.firebaserc` の作成

```bash
# プロジェクトルートに .firebaserc を作成
cat > .firebaserc << 'EOF'
{
  "projects": {
    "default": "completely-understood-vol61"
  }
}
EOF
```

### 3. バックエンドの Firebase Functions 対応

#### `apps/backend/package.json` の作成

```bash
# apps/backend/package.json の作成
cat > apps/backend/package.json << 'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Rust backend for Firebase Functions",
  "main": "index.js",
  "engines": {
    "node": "20"
  },
  "dependencies": {
    "firebase-functions": "^4.0.0",
    "firebase-admin": "^12.0.0"
  }
}
EOF
```

#### `apps/backend/index.js` の作成

```bash
# apps/backend/index.js の作成
cat > apps/backend/index.js << 'EOF'
const functions = require('firebase-functions');
const { spawn } = require('child_process');

exports.api = functions.https.onRequest((req, res) => {
  // CORS ヘッダーの設定
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Rust バックエンドの実行
  const rustProcess = spawn('./target/release/backend', [], {
    stdio: ['pipe', 'pipe', 'pipe'],
  });

  let data = '';
  let error = '';

  rustProcess.stdout.on('data', (chunk) => {
    data += chunk;
  });

  rustProcess.stderr.on('data', (chunk) => {
    error += chunk;
  });

  rustProcess.on('close', (code) => {
    if (code !== 0) {
      res.status(500).json({ error: error });
    } else {
      res.status(200).json(JSON.parse(data));
    }
  });

  // リクエストボディをRustプロセスに送信
  rustProcess.stdin.write(JSON.stringify(req.body));
  rustProcess.stdin.end();
});
EOF
```

### 4. フロントエンド環境設定の追加

```bash
# 環境設定ディレクトリの作成
mkdir -p apps/frontend/src/environments

# 開発環境設定
cat > apps/frontend/src/environments/environment.ts << 'EOF'
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080',
};
EOF

# 本番環境設定
cat > apps/frontend/src/environments/environment.prod.ts << 'EOF'
export const environment = {
  production: true,
  apiUrl: 'https://us-central1-completely-understood-vol61.cloudfunctions.net/api',
};
EOF
```

### 5. CI/CD パイプラインの設定

```bash
# .github/workflows/deploy.yml の作成
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Firebase

on:
  push:
    branches:
      - main

permissions:
  actions: read
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # Node.js のセットアップ
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      # Rust のセットアップ
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          override: true

      # 依存関係のインストール
      - run: npm ci --legacy-peer-deps
      - run: npx cypress install

      # Nx Cloud の設定
      - uses: nrwl/nx-set-shas@v4

      # ビルド
      - run: npx nx build frontend --configuration=production
      - run: npx nx build backend --configuration=production

      # Firebase CLI のインストール
      - run: npm install -g firebase-tools

      # Firebase へのデプロイ
      - run: firebase deploy --token "${{ secrets.FIREBASE_TOKEN }}" --non-interactive
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
EOF
```

### 6. Firebase Token の設定

```bash
# 1. Firebase CLI でトークンを生成
firebase login:ci

# 2. 生成されたトークンをコピー

# 3. GitHub リポジトリの設定
# Settings > Secrets and variables > Actions > New repository secret
# Name: FIREBASE_TOKEN
# Value: コピーしたトークン
```

### 7. ローカルでのテスト

```bash
# 1. フロントエンドのビルド
npx nx build frontend --configuration=production

# 2. バックエンドのビルド
npx nx build backend --configuration=production

# 3. Firebase エミュレーターでのテスト
firebase emulators:start

# 4. ブラウザで http://localhost:5000 にアクセスしてテスト
```

### 8. 本番環境へのデプロイ

```bash
# 1. 初回デプロイ
firebase deploy

# 2. 個別デプロイ（必要に応じて）
firebase deploy --only hosting
firebase deploy --only functions

# 3. デプロイ状況の確認
firebase projects:list
firebase hosting:sites:list
firebase functions:list
```

## 環境変数の管理

### Firebase Functions の環境変数

```bash
firebase functions:config:set api.key="your-api-key"
firebase functions:config:set cors.origin="https://your-domain.com"
```

### ローカル開発用の環境変数

```bash
# .env.local
FIREBASE_PROJECT_ID=completely-understood-vol61
FIREBASE_API_KEY=your-api-key
```

## トラブルシューティング

### よくある問題と解決方法

#### 1. CORS エラー

- Firebase Functions で CORS ヘッダーが正しく設定されているか確認
- フロントエンドの API URL が正しいか確認

#### 2. ビルドエラー

- Node.js と Rust のバージョンが正しいか確認
- 依存関係が正しくインストールされているか確認

#### 3. デプロイエラー

- Firebase プロジェクト ID が正しいか確認
- Firebase CLI が最新版か確認

### デバッグコマンド

```bash
# ローカルでの Firebase エミュレーション
firebase emulators:start

# ログの確認
firebase functions:log

# 設定の確認
firebase functions:config:get

# よくある問題の解決
firebase logout && firebase login  # 認証問題
firebase use --add  # プロジェクト選択問題
firebase functions:config:unset api.key  # 設定リセット
```

## パフォーマンス最適化

### フロントエンド

- Angular の AOT コンパイルを有効化
- コード分割と遅延ローディングの実装
- 静的アセットの最適化

### バックエンド

- Rust のリリースビルドを使用
- 適切なメモリ管理
- キャッシュ戦略の実装

## セキュリティ

### Firebase Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 環境変数の管理

- 機密情報は Firebase Functions の環境変数として管理
- ローカル開発用の環境変数は `.env.local` で管理（Git にコミットしない）

## 監視とログ

### Firebase Analytics

- フロントエンドのユーザー行動分析
- パフォーマンス監視

### Firebase Functions ログ

- バックエンドの実行ログ
- エラー監視

## 追加設定（オプション）

### カスタムドメインの設定

```bash
# 1. カスタムドメインの追加
firebase hosting:sites:add your-custom-domain

# 2. DNS レコードの設定
# A レコード: 151.101.1.195
# A レコード: 151.101.65.195

# 3. SSL 証明書の確認
firebase hosting:sites:list
```

### セキュリティと最適化

```bash
# 1. Firebase Security Rules の設定
firebase deploy --only firestore:rules

# 2. 環境変数の設定
firebase functions:config:set api.key="your-api-key"
firebase functions:config:set cors.origin="https://your-domain.com"

# 3. 設定の確認
firebase functions:config:get
```

## デプロイ完了後の確認事項

1. **フロントエンド**: https://completely-understood-vol61.web.app でアクセス可能
2. **バックエンド**: https://us-central1-completely-understood-vol61.cloudfunctions.net/api で API 呼び出し可能
3. **CI/CD**: main ブランチへのプッシュで自動デプロイ
4. **監視**: Firebase Console でログとパフォーマンスを確認

## パフォーマンス指標

- **フロントエンド**: Lighthouse スコア 90+
- **バックエンド**: レスポンス時間 < 200ms
- **デプロイ時間**: < 5 分（Nx Cloud 活用時）

## 参考リンク

- [Firebase 公式ドキュメント](https://firebase.google.com/docs)
- [Nx 公式ドキュメント](https://nx.dev/)
- [Angular 公式ドキュメント](https://angular.io/docs)
- [Rust 公式ドキュメント](https://doc.rust-lang.org/)

➜ completely-understood-vol61 git:(refactor/firebase) firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

/Users/akihiko.kigure/work/completely-understood-vol61

✔ Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Functions: Configure a Cloud Functions directory and its files, Hosting: Configure files for Firebase Hosting
and (optionally) set up GitHub Action deploys

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

✔ Please select an option: Use an existing project
✔ Select a default Firebase project for this directory: completely-understood-vo-a0f23 (completely-understood-vol61)
i Using project completely-understood-vo-a0f23 (completely-understood-vol61)

=== Functions Setup
Let's create a new codebase for your functions.
A directory corresponding to the codebase will be created in your project
with sample code pre-configured.

See https://firebase.google.com/docs/functions/organize-functions for
more information on organizing your functions using codebases.

Functions can be deployed with firebase deploy.

✔ What language would you like to use to write Cloud Functions? TypeScript
✔ Do you want to use ESLint to catch probable bugs and enforce style? Yes
✔ Wrote functions/package.json
✔ Wrote functions/.eslintrc.js
✔ Wrote functions/tsconfig.dev.json
✔ Wrote functions/tsconfig.json
✔ Wrote functions/src/index.ts
✔ Wrote functions/.gitignore
✔ Do you want to install dependencies with npm now? Yes

up to date, audited 694 packages in 666ms

162 packages are looking for funding
run `npm fund` for details

found 0 vulnerabilities

=== Hosting Setup

Your public directory is the folder (relative to your project directory) that
will contain Hosting assets to be uploaded with firebase deploy. If you
have a build process for your assets, use your build's output directory.

✔ What do you want to use as your public directory? dist/apps/frontend/browser
✔ Configure as a single-page app (rewrite all urls to /index.html)? No
✔ Set up automatic builds and deploys with GitHub? Yes
✔ Wrote dist/apps/frontend/browser/404.html
✔ File dist/apps/frontend/browser/index.html already exists. Overwrite? Yes
✔ Wrote dist/apps/frontend/browser/index.html

i Detected a .git folder at /Users/akihiko.kigure/work/completely-understood-vol61
i Authorizing with GitHub to upload your service account to a GitHub repository's secrets store.

Visit this URL on this device to log in:
https://github.com/login/oauth/authorize?client_id=89cf50f02ac6aaed3484&state=556944599&redirect_uri=http%3A%2F%2Flocalhost%3A9005&scope=read%3Auser%20repo%20public_repo

Waiting for authentication...

✔ Success! Logged into GitHub as gurezo

✔ For which GitHub repository would you like to set up a GitHub workflow? (format: user/repository) gurezo/completely-understood-vol61

✔ Created service account github-action-915649637 with Firebase Hosting admin permissions.
✔ Uploaded service account JSON to GitHub as secret FIREBASE_SERVICE_ACCOUNT_COMPLETELY_UNDERSTOOD_VO_A0F23.
i You can manage your secrets at https://github.com/gurezo/completely-understood-vol61/settings/secrets.

✔ Set up the workflow to run a build script before every deploy? Yes
✔ What script should be run before every deploy? npm ci && npm run build

✔ Created workflow file /Users/akihiko.kigure/work/completely-understood-vol61/.github/workflows/firebase-hosting-pull-request.yml
✔ Set up automatic deployment to your site's live channel when a PR is merged? Yes
✔ What is the name of the GitHub branch associated with your site's live channel? main

✔ Created workflow file /Users/akihiko.kigure/work/completely-understood-vol61/.github/workflows/firebase-hosting-merge.yml

i Action required: Visit this URL to revoke authorization for the Firebase CLI GitHub OAuth App:
https://github.com/settings/connections/applications/89cf50f02ac6aaed3484
i Action required: Push any new workflow file(s) to your repo

✔ Wrote configuration info to firebase.json
✔ Wrote project information to .firebaserc

✔ Firebase initialization complete!
➜ completely-understood-vol61 git:(refactor/firebase) ✗

---

➜ completely-understood-vol61 git:(refactor/firebase) firebase init

####### ######### ######## ######## ######## ######## ########

##

ここで Firebase プロジェクトを初期化しますディレクトリ:

/Users/akihiko.kigure/work/completely-understood-vol61

✔ このディレクトリにどの Firebase 機能を設定しますか？ Space キーを押して機能を選択し、Enter キーを押して選択を確定します。Functions: Cloud Functions ディレクトリとそのファイルを設定します。Hosting: Firebase Hosting 用のファイルを設定します。
また、必要に応じて GitHub Action のデプロイを設定します。

=== プロジェクトのセットアップ

まず、このプロジェクトディレクトリを Firebase プロジェクトに関連付けます。
firebase use --add を実行することで複数のプロジェクトエイリアスを作成できますが、今はデフォルトのプロジェクトだけを設定します。

✔ オプションを選択してください: 既存のプロジェクトを使用する
✔ このディレクトリのデフォルトの Firebase プロジェクトを選択してください: completely-understood-vo-a0f23 (completely-understood-vol61)
i プロジェクト completely-understood-vo-a0f23 (completely-understood-vol61) を使用する

=== Functions のセットアップ
Functions 用の新しいコードベースを作成しましょう。
プロジェクト内に、コードベースに対応するディレクトリが作成され、サンプルコードが事前に構成されます。

コードベースを使用した Functions の整理方法の詳細については、https://firebase.google.com/docs/functions/organize-functions をご覧ください。

Functions は firebase deploy を使用してデプロイできます。

✔ Cloud Functions の記述に使用する言語は？ TypeScript
✔ ESLint を使用して、潜在的なバグを検出し、スタイルを適用しますか？はい
✔ functions/package.json を記述しました
✔ functions/.eslintrc.js を記述しました
✔ functions/tsconfig.dev.json を記述しました
✔ functions/tsconfig.json を記述しました
✔ functions/src/index.ts を記述しました
✔ functions/.gitignore を記述しました
✔ npm で依存関係を今すぐインストールしますか？ はい

最新です。682 ミリ秒で 694 個のパッケージを監査しました

162 個のパッケージが資金を募集しています
詳細については `npm fund` を実行してください

脆弱性は 0 件見つかりました

=== ホスティング設定

パブリックディレクトリは、Firebase Deploy でアップロードする Hosting アセットを格納するフォルダ（プロジェクトディレクトリからの相対パス）です。アセットのビルドプロセスがある場合は、ビルドの出力ディレクトリを使用してください。

✔ パブリックディレクトリとして何を使用しますか？ public
✔ シングルページアプリとして構成しますか（すべての URL を /index.html に書き換えます）？はい
✔ GitHub で自動ビルドとデプロイを設定しますか？ はい
✔ public/index.html を書き込みました

i /Users/akihiko.kigure/work/completely-understood-vol61 に .git フォルダが検出されました
i GitHub でサービスアカウントを GitHub リポジトリのシークレットストアにアップロードすることを承認しています。

このデバイスでこの URL にアクセスしてログインしてください:
https://github.com/login/oauth/authorize?client_id=89cf50f02ac6aaed3484&state=1050271027&redirect_uri=http%3A%2F%2Flocalhost%3A9005&scope=read%3Auser%20repo%20public_repo

認証を待機しています...

✔ 成功しました！ gurezo として GitHub にログインしました

✔ どの GitHub リポジトリに対して GitHub ワークフローを設定しますか？ (形式: ユーザー/リポジトリ) gurezo/completely-understood-vol61

✔ Firebase Hosting の管理者権限を持つサービスアカウント github-action-915649637 を作成しました。
✔ サービスアカウントの JSON ファイルを GitHub にシークレット FIREBASE_SERVICE_ACCOUNT_COMPLETELY_UNDERSTOOD_VO_A0F23 としてアップロードしました。
i シークレットは https://github.com/gurezo/completely-understood-vol61/settings/secrets で管理できます。

✔ 毎回のデプロイ前にビルドスクリプトを実行するワークフローを設定しましたか？ はい
✔ 毎回のデプロイ前にどのスクリプトを実行する必要がありますか？ npm ci && npm run build

✔ ワークフローファイル /Users/akihiko.kigure/work/completely-understood-vol61/.github/workflows/firebase-hosting-pull-request.yml を作成しましたか？
✔ PR がマージされたときに、サイトのライブチャンネルへの自動デプロイを設定しましたか？ はい
✔ サイトのライブチャンネルに関連付けられている GitHub ブランチの名前は何ですか？ main

✔ ワークフローファイル /Users/akihiko.kigure/work/completely-understood-vol61/.github/workflows/firebase-hosting-merge.yml を作成しました。

i 必要なアクション: Firebase CLI GitHub OAuth アプリの承認を取り消すには、この URL にアクセスしてください:
https://github.com/settings/connections/applications/89cf50f02ac6aaed3484
i 必要なアクション: 新しいワークフローファイルをリポジトリにプッシュしてください。

✔ 設定情報を firebase.json に書き込みました。
✔ プロジェクト情報を .firebaserc に書き込みました。

✔ Firebase の初期化が完了しました！
➜ completely-understood-vol61 git:(refactor/firebase) ✗

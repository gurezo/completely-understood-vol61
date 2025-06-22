const functions = require('firebase-functions');
const { spawn } = require('child_process');
const http = require('http');
const path = require('path');

// メモリキャッシュ（注意: 関数インスタンス間では共有されません）
const cache = new Map();
const CACHE_TTL = 5 * 60 * 1000; // 5分

// Rustサーバーの設定
const RUST_SERVER_HOST = '127.0.0.1';
const RUST_SERVER_PORT = 8080;

// Rustサーバーを起動する関数
function startRustServer() {
  return new Promise((resolve, reject) => {
    // ワークスペースルートのtarget/release/backendを参照
    const backendPath = path.join(
      __dirname,
      '..',
      '..',
      'target',
      'release',
      'backend'
    );
    console.log('Starting Rust server from:', backendPath);

    const rustProcess = spawn(backendPath, [], {
      stdio: 'pipe',
      cwd: path.join(__dirname, '..', '..'), // ワークスペースルートをcwdに設定
    });

    rustProcess.stderr.on('data', (data) => {
      console.log('Rust server stderr:', data.toString());
    });

    // サーバーが起動するまで少し待つ
    setTimeout(() => {
      resolve(rustProcess);
    }, 2000);

    rustProcess.on('error', (err) => {
      console.error('Failed to start Rust server:', err);
      reject(err);
    });
  });
}

// RustサーバーにHTTPリクエストを送信する関数
function sendRequestToRust(data) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify(data);

    const options = {
      hostname: RUST_SERVER_HOST,
      port: RUST_SERVER_PORT,
      path: '/api/double',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
      },
    };

    const req = http.request(options, (res) => {
      let responseData = '';

      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        try {
          const parsedData = JSON.parse(responseData);
          resolve(parsedData);
        } catch (error) {
          reject(new Error('Invalid JSON response from Rust server'));
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    req.write(postData);
    req.end();
  });
}

// グローバル変数でRustプロセスを管理
let rustProcess = null;

exports.api = functions.https.onRequest(async (req, res) => {
  // CORS ヘッダーの設定
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.set(
    'Access-Control-Allow-Headers',
    'Content-Type, Authorization, X-Requested-With'
  );
  res.set('Access-Control-Max-Age', '86400');

  // OPTIONS リクエストの処理
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  try {
    // キャッシュキーの生成
    const cacheKey = `cache:${JSON.stringify(req.body)}`;

    // キャッシュから取得を試行
    const cached = cache.get(cacheKey);
    if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
      return res.json(cached.data);
    }

    // Rustサーバーが起動していない場合は起動
    if (!rustProcess) {
      console.log('Starting Rust server...');
      rustProcess = await startRustServer();
      console.log('Rust server started');
    }

    // Rustサーバーにリクエストを送信
    const result = await sendRequestToRust(req.body);

    // 結果をキャッシュに保存
    cache.set(cacheKey, {
      data: result,
      timestamp: Date.now(),
    });

    res.status(200).json(result);
  } catch (error) {
    console.error('Function error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

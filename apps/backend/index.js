const functions = require('firebase-functions');
const { spawn } = require('child_process');

// メモリキャッシュ（注意: 関数インスタンス間では共有されません）
const cache = new Map();
const CACHE_TTL = 5 * 60 * 1000; // 5分

exports.api = functions.https.onRequest(async (req, res) => {
  // CORS ヘッダーの設定（改善版）
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.set(
    'Access-Control-Allow-Headers',
    'Content-Type, Authorization, X-Requested-With'
  );
  res.set('Access-Control-Max-Age', '86400'); // 24時間

  // OPTIONS リクエスト（プリフライト）の処理
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
        console.error('Rust process error:', error);
        res.status(500).json({ error: error || 'Internal server error' });
      } else {
        try {
          const parsedData = JSON.parse(data);
          // 結果をキャッシュに保存
          cache.set(cacheKey, {
            data: parsedData,
            timestamp: Date.now(),
          });
          res.status(200).json(parsedData);
        } catch (parseError) {
          console.error('JSON parse error:', parseError);
          res.status(500).json({ error: 'Invalid JSON response from backend' });
        }
      }
    });

    rustProcess.on('error', (err) => {
      console.error('Rust process spawn error:', err);
      res.status(500).json({ error: 'Failed to start backend process' });
    });

    // リクエストボディをRustプロセスに送信
    if (req.body) {
      rustProcess.stdin.write(JSON.stringify(req.body));
    }
    rustProcess.stdin.end();
  } catch (error) {
    console.error('Function error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

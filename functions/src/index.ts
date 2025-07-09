/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import cors from 'cors';
import { setGlobalOptions } from 'firebase-functions';
import { onRequest } from 'firebase-functions/https';
import * as logger from 'firebase-functions/logger';

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// CORS設定
const corsHandler = cors({
  origin: [
    'http://localhost:4200', // Angular dev server
    'http://127.0.0.1:4200',
    'http://localhost:5002', // Firebase hosting emulator
    'http://127.0.0.1:5002',
    'https://your-production-domain.com', // 本番環境のドメイン
  ],
  credentials: true,
});

// 数値を2倍にするエンドポイント
export const double = onRequest((request, response) => {
  corsHandler(request, response, () => {
    logger.info('Double function called!', { structuredData: true });

    if (request.method !== 'POST') {
      response.status(405).json({
        error: 'Method not allowed',
        allowedMethods: ['POST'],
      });
      return;
    }

    try {
      const { value } = request.body;

      if (typeof value !== 'number') {
        response.status(400).json({
          error: 'Invalid input: value must be a number',
        });
        return;
      }

      const result = value * 2;

      response.json({
        result: result,
      });

      logger.info('Double calculation completed', {
        input: value,
        result: result,
      });
    } catch (error) {
      logger.error('Error in double function:', error);
      response.status(500).json({
        error: 'Internal server error',
      });
    }
  });
});

// APIエンドポイントの例
export const api = onRequest((request, response) => {
  corsHandler(request, response, () => {
    logger.info('API called!', { structuredData: true });

    // パスベースのルーティング
    const path = request.path;

    if (path === '/double') {
      // doubleエンドポイントの処理
      if (request.method !== 'POST') {
        response.status(405).json({
          error: 'Method not allowed',
          allowedMethods: ['POST'],
        });
        return;
      }

      try {
        const { value } = request.body;

        if (typeof value !== 'number') {
          response.status(400).json({
            error: 'Invalid input: value must be a number',
          });
          return;
        }

        const result = value * 2;

        response.json({
          result: result,
        });

        logger.info('Double calculation completed', {
          input: value,
          result: result,
        });
      } catch (error) {
        logger.error('Error in double function:', error);
        response.status(500).json({
          error: 'Internal server error',
        });
      }
      return;
    }

    // デフォルトのAPI処理
    if (request.method === 'GET') {
      response.json({
        message: 'Hello from Firebase Functions API!',
        timestamp: new Date().toISOString(),
        method: request.method,
      });
    } else if (request.method === 'POST') {
      response.json({
        message: 'Data received successfully!',
        data: request.body,
        timestamp: new Date().toISOString(),
        method: request.method,
      });
    } else {
      response.status(405).json({
        error: 'Method not allowed',
        allowedMethods: ['GET', 'POST'],
      });
    }
  });
});

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

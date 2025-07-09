/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from 'firebase-functions';
import { onRequest } from 'firebase-functions/https';
import * as logger from 'firebase-functions/logger';

setGlobalOptions({ maxInstances: 10 });

const RUST_BACKEND_URL =
  process.env.RUST_BACKEND_URL || 'http://127.0.0.1:8080';

// 数値を2倍にするエンドポイント - Rust Backendに転送
export const double = onRequest(async (request, response) => {
  // CORS設定を直接設定
  response.set('Access-Control-Allow-Origin', '*');
  response.set(
    'Access-Control-Allow-Methods',
    'GET, POST, PUT, DELETE, OPTIONS'
  );
  response.set(
    'Access-Control-Allow-Headers',
    'Content-Type, Authorization, X-Requested-With, Accept, Origin'
  );
  response.set('Access-Control-Max-Age', '3600');

  // プリフライトリクエストの処理
  if (request.method === 'OPTIONS') {
    response.status(204).send('');
    return;
  }

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

    const backendResponse = await fetch(`${RUST_BACKEND_URL}/api/double`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ value }),
    });

    if (!backendResponse.ok) {
      logger.error('Backend request failed:', {
        status: backendResponse.status,
        statusText: backendResponse.statusText,
      });
      response.status(502).json({
        error: 'Backend service unavailable',
      });
      return;
    }

    const result = await backendResponse.json();
    response.json(result);
  } catch (error) {
    logger.error('Error in double function:', error);
    response.status(500).json({
      error: 'Internal server error',
    });
  }
});

// APIエンドポイント - /api/doubleパスを処理
export const api = onRequest(async (request, response) => {
  // CORS設定を直接設定
  response.set('Access-Control-Allow-Origin', '*');
  response.set(
    'Access-Control-Allow-Methods',
    'GET, POST, PUT, DELETE, OPTIONS'
  );
  response.set(
    'Access-Control-Allow-Headers',
    'Content-Type, Authorization, X-Requested-With, Accept, Origin'
  );
  response.set('Access-Control-Max-Age', '3600');

  // プリフライトリクエストの処理
  if (request.method === 'OPTIONS') {
    response.status(204).send('');
    return;
  }

  const path = request.path;

  if (path === '/double') {
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

      const backendResponse = await fetch(`${RUST_BACKEND_URL}/api/double`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
        },
        body: JSON.stringify({ value }),
      });

      if (!backendResponse.ok) {
        logger.error('Backend request failed:', {
          status: backendResponse.status,
          statusText: backendResponse.statusText,
        });
        response.status(502).json({
          error: 'Backend service unavailable',
        });
        return;
      }

      const result = await backendResponse.json();
      response.json(result);
    } catch (error) {
      logger.error('Error in double function:', error);
      response.status(500).json({
        error: 'Internal server error',
      });
    }
    return;
  }

  // デフォルトのAPI処理
  response.status(404).json({
    error: 'Endpoint not found',
    availableEndpoints: ['/double'],
  });
});

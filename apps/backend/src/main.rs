use actix_web::{web, App, HttpServer, Responder, http};
use serde::{Deserialize, Serialize};
use actix_cors::Cors;
use std::env;

#[derive(Deserialize)]
struct InputValue {
    value: i32,
}

#[derive(Serialize)]
struct OutputValue {
    result: i32,
}

async fn double_value(input: web::Json<InputValue>) -> impl Responder {
    let result = input.value * 2;
    web::Json(OutputValue { result })
}

async fn health_check() -> impl Responder {
    "OK"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // 環境変数の詳細をログ出力
    println!("=== Environment Variables ===");
    for (key, value) in env::vars() {
        if key.contains("PORT") || key.contains("RUST") || key.contains("K_SERVICE") {
            println!("{}: {}", key, value);
        }
    }
    println!("=============================");

    let port = env::var("PORT").unwrap_or_else(|_| "8080".to_string());
    let bind_address = format!("0.0.0.0:{}", port);

    println!("Starting server on {}", bind_address);
    println!("PORT environment variable: {:?}", env::var("PORT"));
    println!("Binding to address: {}", bind_address);
    println!("Server starting up...");

    // CORS設定を環境変数から取得
    let cors_origins = env::var("CORS_ALLOWED_ORIGINS")
        .unwrap_or_else(|_| "http://127.0.0.1:5002,http://localhost:5002,http://127.0.0.1:4200,http://localhost:4200,https://completely-understood-vo-a0f23.web.app".to_string());

    let server = HttpServer::new(move || {
        let mut cors = Cors::default()
            .allowed_methods(vec!["GET", "POST", "PUT", "DELETE", "OPTIONS"])
            .allowed_headers(vec![http::header::AUTHORIZATION, http::header::ACCEPT, http::header::CONTENT_TYPE])
            .supports_credentials();

        // 環境変数からCORS originsを設定
        for origin in cors_origins.split(',') {
            let origin = origin.trim();
            if !origin.is_empty() {
                cors = cors.allowed_origin(origin);
            }
        }

        App::new()
            .wrap(cors)
            .service(web::resource("/api/double").route(web::post().to(double_value)))
            .service(web::resource("/").route(web::get().to(health_check)))
    })
    .bind(&bind_address)?;

    println!("Server bound successfully to {}", bind_address);
    println!("Starting HTTP server...");

    server.run().await
}

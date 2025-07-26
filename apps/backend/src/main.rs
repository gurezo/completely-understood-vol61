use actix_web::{web, App, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use actix_cors::Cors;

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

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
             .wrap(Cors::default().allow_any_origin().allow_any_method().allow_any_header())
            .service(web::resource("/api/double").route(web::post().to(double_value)))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}

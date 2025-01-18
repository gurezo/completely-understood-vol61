use actix_web::{web, App, HttpServer, Responder};
use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
struct InputValue {
    value: i32,
}

#[derive(Serialize)]
struct OutputValue {
    result: i32,
}

fn main() {
    println!("Hello, world!");
}

//! # wt-rest-api
//!
//! REST api server application for the walkie-talkie project.

// rustc
#![cfg_attr(debug_assertions, allow(unused))]
#![cfg_attr(not(debug_assertions), deny(missing_docs))]
#![cfg_attr(not(debug_assertions), deny(clippy::unwrap_used))]
#![cfg_attr(not(debug_assertions), deny(warnings))]
// clippy
#![cfg_attr(not(debug_assertions), deny(clippy::todo))]
#![cfg_attr(
    not(any(test, debug_assertions)),
    deny(clippy::print_stdout, clippy::dbg_macro)
)]

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    // let _database_url = get_database_url();
    let addr = std::net::SocketAddr::from(([0, 0, 0, 0], 8080));
    wt_rest_api::start_server(addr).await;
}

// fn get_database_url() -> String {
//     const DATABASE_URL: &str = "DATABASE_URL";
//     std::env::var(DATABASE_URL).unwrap_or_else(|e| {
//         tracing::error!("{e}");
//         panic!("cannot find env var: {DATABASE_URL}");
//     })
// }

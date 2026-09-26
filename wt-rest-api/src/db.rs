// Note: This is a work around to mute the "used dependency" linting warning.
#[expect(unused_imports)]
use sqlx::PgPool;

// pub(crate) async fn connection_pool(database_url: &str) -> Result<sqlx::PgPool, sqlx::Error> {
//     let pool = sqlx::postgres::PgPoolOptions::new()
//         .max_connections(5)
//         .connect(database_url)
//         .await?;
//     Ok(pool)
// }

// #![cfg_attr(debug_assertions, allow(unused))]

use axum::extract::ws::{WebSocket, WebSocketUpgrade};
use futures::{sink::SinkExt, stream::StreamExt};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::{broadcast, Mutex};
use tracing::info;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let state = AppState {
        channels: Arc::new(Mutex::new(Vec::new())),
    };

    let app = axum::Router::new()
        .route("/", axum::routing::get(websocket_handler))
        .with_state(state);

    let addr = std::net::SocketAddr::from(([0, 0, 0, 0], 3000));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    tracing::info!("listening at http://localhost:{}", addr.port());

    axum::serve(listener, app).await.unwrap();
}

#[derive(Serialize, Deserialize, Clone)]
struct WalkieTalkieMessage {
    channel: String,
    sender: String,
    payload: String,
}

#[derive(Clone)]
struct AppState {
    #[expect(clippy::type_complexity)]
    channels: Arc<Mutex<Vec<(String, broadcast::Sender<WalkieTalkieMessage>)>>>,
}

async fn websocket_handler(
    ws: WebSocketUpgrade,
    axum::extract::State(state): axum::extract::State<AppState>,
) -> axum::response::Response {
    ws.on_upgrade(|socket| handle_socket(socket, state))
}

async fn handle_socket(mut socket: WebSocket, state: AppState) {
    // Receive initial message to determine channel and sender
    if let Some(Ok(msg)) = socket.recv().await
        && let Ok(message) =
            serde_json::from_str::<WalkieTalkieMessage>(msg.to_text().unwrap_or_default())
    {
        let channel_name = message.channel.clone();
        let sender = message.sender.clone();

        // Get or create broadcast channel
        let tx = {
            let mut channels = state.channels.lock().await;

            channels
                .iter()
                .find(|(name, _)| name == &channel_name)
                .map(|(_, tx)| tx.clone())
                .unwrap_or_else(|| {
                    let (tx, _) = broadcast::channel(100);
                    channels.push((channel_name.clone(), tx.clone()));
                    tx
                })
        };

        // Subscribe to the channel
        let mut rx = tx.subscribe();

        // Send confirmation to client
        let _ = socket
            .send(axum::extract::ws::Message::Text(
                serde_json::to_string(&WalkieTalkieMessage {
                    channel: channel_name.clone(),
                    sender: "system".to_owned(),
                    payload: format!("Connected to channel {channel_name}"),
                })
                .unwrap()
                .into(),
            ))
            .await;

        // Split WebSocket for concurrent send/receive
        let (mut ws_sink, mut ws_stream) = socket.split();

        // Task to receive messages from client and broadcast
        let tx_clone = tx.clone();
        let channel_name_clone = channel_name.clone();
        tokio::spawn(async move {
            while let Some(Ok(msg)) = ws_stream.next().await {
                if let Ok(message) =
                    serde_json::from_str::<WalkieTalkieMessage>(msg.to_text().unwrap_or_default())
                    && message.channel == channel_name_clone
                {
                    let _ = tx_clone.send(message);
                }
            }
            info!(
                "Client {} disconnected from channel {}",
                sender, channel_name_clone
            );
        });

        let sender = message.sender.clone();
        // Task to forward broadcasted messages to client
        while let Ok(message) = rx.recv().await {
            if message.channel == channel_name && message.sender != sender {
                let _ = ws_sink
                    .send(axum::extract::ws::Message::Text(
                        serde_json::to_string(&message).unwrap().into(),
                    ))
                    .await;
            }
        }
    }
}

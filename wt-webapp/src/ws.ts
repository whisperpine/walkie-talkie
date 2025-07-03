import { addMessage } from "./chat";

interface WalkieTalkieMessage {
  channel: string;
  sender: string;
  payload: string;
}

const VITE_WEBSOCKET_API_ENDPOINT = import.meta.env
  .VITE_WEBSOCKET_API_ENDPOINT as string;
console.log(`websocket api endpoint: "${VITE_WEBSOCKET_API_ENDPOINT}"`);

function getRandomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const nurseNumber = getRandomInt(1, 1000);

class WebSocketManager {
  private ws: WebSocket | null = null;
  private url: string;
  private reconnectAttempts: number = 0;
  private maxReconnectAttempts: number = 5;
  private reconnectInterval: number = 1000; // Initial delay in ms
  private maxReconnectInterval: number = 30000; // Max delay in ms
  private reconnectTimeout: number | null = null;
  private isReconnecting: boolean = false;
  private heartbeatInterval: number | null = null;
  private channel: string = "ward_08";
  private sender: string = `nurse_${nurseNumber}`;

  constructor(url: string) {
    this.url = url;
  }

  connect(): void {
    // Avoid creating a new connection if already reconnecting
    if (this.isReconnecting) return;

    // Clean up any existing WebSocket
    this.cleanup();

    this.ws = new WebSocket(this.url);

    // Handle WebSocket open
    this.ws.onopen = (): void => {
      console.log("WebSocket connected");
      this.reconnectAttempts = 0; // Reset attempts on successful connection
      this.isReconnecting = false;

      // Send initial message
      this.send({
        channel: this.channel,
        sender: this.sender,
        payload: "",
      });

      // Start heartbeat
      this.startHeartbeat();
    };

    // Handle WebSocket errors
    this.ws.onerror = (error: Event): void => {
      console.error("WebSocket error:", error);
      this.handleReconnect();
    };

    // Handle WebSocket close
    this.ws.onclose = (event: CloseEvent): void => {
      console.log(
        `WebSocket closed: Code=${event.code}, Reason=${event.reason}`,
      );
      this.stopHeartbeat();
      this.handleReconnect();
    };

    // Handle incoming messages
    this.ws.onmessage = (event: MessageEvent<string>): void => {
      try {
        const wtm: WalkieTalkieMessage = JSON.parse(event.data);
        console.log("Received:", event.data);
        if (wtm.payload === "pong") {
          console.log("Heartbeat pong received");
          return;
        }
        addMessage(`${wtm.payload} --- FROM: ${wtm.sender}`, false);
      } catch (error) {
        console.error("Failed to parse message:", error);
      }
    };
  }

  private cleanup(): void {
    if (this.ws) {
      this.ws.onopen = null;
      this.ws.onerror = null;
      this.ws.onclose = null;
      this.ws.onmessage = null;
      if (
        this.ws.readyState === WebSocket.OPEN ||
        this.ws.readyState === WebSocket.CONNECTING
      ) {
        this.ws.close();
      }
      this.ws = null;
    }
    if (this.reconnectTimeout) {
      clearTimeout(this.reconnectTimeout);
      this.reconnectTimeout = null;
    }
    this.stopHeartbeat();
  }

  private handleReconnect(): void {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.error("Max reconnection attempts reached. Giving up.");
      this.cleanup();
      addMessage("Connection lost. Please refresh the page.", false);
      return;
    }

    if (this.isReconnecting) return;

    this.isReconnecting = true;
    this.reconnectAttempts++;

    // Calculate delay with exponential backoff
    const delay = Math.min(
      this.reconnectInterval * Math.pow(2, this.reconnectAttempts),
      this.maxReconnectInterval,
    );

    console.log(
      `Attempting to reconnect in ${delay}ms (Attempt ${this.reconnectAttempts})`,
    );

    this.reconnectTimeout = setTimeout(() => {
      console.log("Reconnecting...");
      this.connect();
    }, delay);
  }

  private startHeartbeat(): void {
    this.stopHeartbeat(); // Clear any existing heartbeat
    this.heartbeatInterval = setInterval(() => {
      if (this.ws && this.ws.readyState === WebSocket.OPEN) {
        // this.send({
        //   channel: this.channel,
        //   sender: this.sender,
        //   payload: "ping",
        // });
      } else {
        console.error("Heartbeat failed: WebSocket not open");
        this.handleReconnect();
      }
    }, 30000); // Send ping every 30 seconds
  }

  private stopHeartbeat(): void {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
  }

  send(message: WalkieTalkieMessage): void {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      try {
        this.ws.send(JSON.stringify(message));
      } catch (error) {
        console.error("Failed to send message:", error);
        this.handleReconnect();
      }
    } else {
      console.error("WebSocket is not open. Cannot send message.");
      this.handleReconnect();
    }
  }

  close(): void {
    this.cleanup();
    this.reconnectAttempts = 0;
    this.isReconnecting = false;
  }
}

// Create and initialize WebSocketManager
const wsManager = new WebSocketManager(VITE_WEBSOCKET_API_ENDPOINT);
wsManager.connect();

export function sendMessage(payload: string): void {
  wsManager.send({
    channel: "ward_08",
    sender: `nurse_${nurseNumber}`,
    payload,
  });
}

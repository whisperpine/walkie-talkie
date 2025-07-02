import { addMessage } from "./chat";

interface WalkieTalkieMessage {
  channel: string;
  sender: string;
  payload: string;
}

const VITE_WEBSOCKET_API_ENDPOINT = import.meta.env
  .VITE_WEBSOCKET_API_ENDPOINT as string;
console.log(`websocket api endpoint: "${VITE_WEBSOCKET_API_ENDPOINT}"`);

const ws = new WebSocket(VITE_WEBSOCKET_API_ENDPOINT);

ws.onmessage = (event: MessageEvent<string>): void => {
  const wtm: WalkieTalkieMessage = JSON.parse(event.data);
  console.log("Received:", event.data);
  addMessage(wtm.payload, false);
};

ws.onopen = (): void => {
  ws.send(
    JSON.stringify({
      channel: "ward",
      sender: `nurse_${nurseNumber}`,
      payload: "",
    }),
  );
};

function getRandomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const nurseNumber = getRandomInt(1, 1000);

export function sendMessage(payload: string): void {
  ws.send(
    JSON.stringify({
      channel: "ward",
      sender: `nurse_${nurseNumber}`,
      payload: payload,
    }),
  );
}

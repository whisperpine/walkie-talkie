import "./style.css";
import { setupCounter } from "./counter.ts";
import { setupSendButton } from "./ws.ts";

const app = document.querySelector<HTMLDivElement>("#app");
if (app != null) {
  app.innerHTML = `
  <h1 class="text-3xl font-bold text-blue-900 underline">
    Walkie Talkie
  </h1>
  <div>
    <button id="counter" type="button" class="rounded-2xl shadow-sm"></button>
    
    <button id="send-message" type="button" class="rounded-2xl shadow-sm">send message</button>
  </div>
`;
}

const btn_counter = document.querySelector<HTMLButtonElement>("#counter");
if (btn_counter != null) {
  setupCounter(btn_counter);
}

const btn_send_message = document.querySelector<HTMLButtonElement>(
  "#send-message",
);
if (btn_send_message != null) {
  setupSendButton(btn_send_message);
}

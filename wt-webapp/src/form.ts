import { sendMsg } from "./ws.ts";
import { addMessage } from "./chat.ts";

// script.ts
// Select the form and output element with proper typing
const form = document.getElementById("message-form") as HTMLFormElement;

// Add submit event listener
form.addEventListener("submit", (event: Event) => {
  // Prevent default form submission (e.g., page reload)
  event.preventDefault();

  // Get form data
  const formData = new FormData(form);
  const message = formData.get("message") as string;
  // console.log(message);
  sendMsg(message);
  addMessage(message, true);

  // Reset the form
  form.reset();
});

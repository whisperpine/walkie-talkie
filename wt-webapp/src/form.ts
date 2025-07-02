import { sendMessage } from "./ws.ts";
import { addMessage } from "./chat.ts";

// script.ts
// Select the form and output element with proper typing
const form = document.getElementById("message-form") as HTMLFormElement;

function handle() {
  // Get form data
  const formData = new FormData(form);
  const message = formData.get("message") as string;
  // console.log(message);
  sendMessage(message);
  addMessage(message, true);

  // Reset the form
  form.reset();
}

// Add submit event listener
form.addEventListener("submit", (event: Event) => {
  // Prevent default form submission (e.g., page reload)
  event.preventDefault();

  handle();
});

const textarea = document.getElementById("message") as HTMLTextAreaElement;
textarea.addEventListener(
  "keydown",
  (event) => {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault(); // Prevent adding a newline
      handle();
    }
  },
);

// Interface for a message
interface ChatMessage {
  text: string;
  isSender: boolean;
}
// Function to create a message element
function createMessageElement(message: ChatMessage): HTMLDivElement {
  const messageDiv = document.createElement("div");
  messageDiv.className = `flex ${
    message.isSender ? "justify-end" : "justify-start"
  }`;

  const bubbleDiv = document.createElement("div");
  bubbleDiv.className = `max-w-xs p-3 rounded-lg ${
    message.isSender ? "bg-blue-600 text-white" : "bg-gray-700 text-gray-100"
  }`;
  bubbleDiv.textContent = message.text;

  messageDiv.appendChild(bubbleDiv);
  return messageDiv;
}

// Function to add a message to the chat
export function addMessage(text: string, isSender: boolean): void {
  const chatContainer = document.querySelector<HTMLDivElement>(
    "#chat-container",
  );
  if (!chatContainer) return;

  const message: ChatMessage = { text, isSender };
  const messageElement = createMessageElement(message);
  chatContainer.appendChild(messageElement);

  // Scroll to the latest message
  chatContainer.scrollTop = chatContainer.scrollHeight;
}

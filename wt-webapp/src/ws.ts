const ws = new WebSocket("ws://localhost:3000/ws");

const nurseNumber = getRandomInt(1, 100);

// ws.onopen = (): void => { };

function generateRandomSentence(): string {
  const subjects = ["The cat", "A dog", "My friend", "The robot", "An alien"];
  const verbs = ["jumps", "runs", "flies", "sings", "dances"];
  const objects = ["a ball", "the moon", "a tree", "some code", "a star"];

  const randomItem = <T>(arr: T[]): T =>
    arr[Math.floor(Math.random() * arr.length)];

  return `${randomItem(subjects)} ${randomItem(verbs)} ${randomItem(objects)}.`;
}

function getRandomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

ws.onmessage = (event): void => {
  console.log("Received:", event.data);
};

function sendMessage(): void {
  ws.send(
    JSON.stringify({
      channel: "ward",
      sender: `nurse_${nurseNumber}`,
      payload: generateRandomSentence(),
    }),
  );
}

export function setupSendButton(element: HTMLButtonElement) {
  element.addEventListener("click", () => sendMessage());
}

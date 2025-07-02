import "./style.css";
import typescriptLogo from "./typescript.svg";
import viteLogo from "/vite.svg";
import { setupCounter } from "./counter.ts";

document.querySelector<HTMLDivElement>("#app")!.innerHTML = `
  <h1 class="text-3xl font-bold text-blue-900 underline">
    Walkie Talkie
  </h1>
  <div>
    <a href="https://vite.dev" target="_blank">
      <img src="${viteLogo}" alt="Vite logo" />
    </a>
    <a href="https://www.typescriptlang.org/" target="_blank">
      <img src="${typescriptLogo}" alt="TypeScript logo" />
    </a>
    <button id="counter" type="button" class="rounded-2xl shadow-sm"></button>
  </div>
`;

setupCounter(document.querySelector<HTMLButtonElement>("#counter")!);

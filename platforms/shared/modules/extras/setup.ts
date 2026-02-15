import { npm, shell } from "#shared/src/util.ts"

// Demonstrate how to install cli tools using go, cargo, and npm
export default async function setup() {
  // scc - a util for counting lines of code. https://github.com/boyter/scc
  await shell("go install github.com/boyter/scc/v3@latest")
  // duf - like df, a better disk usage cli tool. https://github.com/muesli/duf
  await shell("go install github.com/muesli/duf@latest")

  // serve - a simple http server that can be run from the command line. https://github.com/vercel/serve
  // fast - test your internet speed from the cli using fast.com. https://github.com/sindresorhus/fast-cli
  await npm("fast-cli serve")

  // ambr - a user friendly cli find and replace tool. https://github.com/dalance/amber
  // bat - like cat, but with syntax highlighting. https://github.com/sharkdp/bat
  // eza - a more colorful ls. https://github.com/eza-community/eza
  await shell("cargo install amber bat eza")
}

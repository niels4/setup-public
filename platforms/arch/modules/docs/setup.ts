import { pacman } from "#arch/arch-util.ts"
import { cmd } from "#shared/util.ts"

export default async function setup() {
  await pacman("tealdeer wikiman arch-wiki-docs")
  await cmd("tldr --update")
}

import { pacman } from "#arch/arch-util.ts"
import { shell } from "#shared/src/util.ts"

export default async function setup() {
  await pacman("man wikiman arch-wiki-docs tealdeer ")
  await shell("tldr --update")
}

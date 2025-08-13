import { pacman } from "#arch/arch-util.ts"
import { shell } from "#shared/src/util.ts"

export default async function setup() {
  await pacman("man wikiman arch-wiki-docs tealdeer ")
  // no need to await this promise, this can update in the background while we move on
  shell("tldr --update", { silent: true })
}

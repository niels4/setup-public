import { pacman } from "#arch/arch-util.ts"
import sharedShellSetup from "#shared/modules/shell/setup.ts"
import { username } from "#shared/src/constants.ts"
import { cmd } from "#shared/src/util.ts"

export default async function setup() {
  await pacman("zsh tmux fzf")
  await cmd(`sudo chsh -s /bin/zsh ${username}`)
  await sharedShellSetup()
}

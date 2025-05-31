import { pacman } from "#arch/arch-util.ts"
import { username } from "#shared/constants.ts"
import sharedShellSetup from "#shared/modules/shell/setup.ts"
import { cmd } from "#shared/util.ts"

export default async function setup() {
  await pacman("zsh tmux fzf")
  await cmd(`sudo chsh -s /bin/zsh ${username}`)
  await sharedShellSetup()
}

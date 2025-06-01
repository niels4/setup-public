import { pacman } from "#arch/arch-util.ts"
import sharedNeovimSetup from "#shared/modules/neovim/setup.ts"

export default async function setup() {
  // ripgrep installed by prereqs
  // fd installed by shell-tools
  await pacman("neovim tree-sitter-cli stylua unzip")
  await sharedNeovimSetup()
}

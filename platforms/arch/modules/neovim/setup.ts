import { pacman } from "#arch/arch-util.ts"
import sharedNeovimSetup from "#shared/modules/neovim/setup.ts"

const packages = ["neovim", "unzip", "tree-sitter-cli"]

export default async function setup() {
  // ripgrep installed by prereqs
  // fd installed by shell-tools
  await pacman(packages.join(" "))
  await sharedNeovimSetup()
}

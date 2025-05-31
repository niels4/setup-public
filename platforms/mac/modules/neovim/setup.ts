import { brewBundle } from "#mac/mac-util.ts"
import sharedNeovimSetup from "#shared/modules/neovim/setup.ts"

export default async function setup() {
  // ripgrep installed by prereqs
  // fd installed by shell-tools
  await brewBundle(import.meta.dirname)
  await sharedNeovimSetup()
}

import { brewBundle } from "#mac/mac-util.ts"
import sharedNeovimSetup from "#shared/modules/neovim/setup.ts"
import { zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { join } from "node:path"

const __dirname = import.meta.dirname

const sshZshConfigLink = {
  src: join(__dirname, "zshrc.d", "neovim.sh"),
  dst: join(zshAutorunDir, "neovim.sh"),
}

export default async function setup() {
  // ripgrep installed by prereqs
  // fd installed by shell-tools
  await brewBundle(import.meta.dirname)
  await sharedNeovimSetup()
  await ensureSymlink(sshZshConfigLink)
}

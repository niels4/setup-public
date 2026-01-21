import { join } from "node:path"
import { brewBundle } from "#mac/mac-util.ts"
import sharedShellSetup from "#shared/modules/shell/setup.ts"
import { zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"

const __dirname = import.meta.dirname

const homebrewZshConfigLink = {
  src: join(__dirname, "zshrc.d", "homebrew.sh"),
  dst: join(zshAutorunDir, "homebrew.sh"),
}

export default async function setup() {
  await brewBundle(import.meta.dirname)
  await sharedShellSetup() // this creates the zshAutorunDir
  await ensureSymlink(homebrewZshConfigLink) // add mac specific call to setup homebrew path
}

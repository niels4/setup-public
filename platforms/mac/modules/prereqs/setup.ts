import { join } from "node:path"
import { brewBundle } from "#mac/mac-util.ts"
import sharedPrereqsSetup from "#shared/modules/prereqs/setup.ts"
import { zshAutorunDir, zshenv } from "#shared/src/constants.ts"
import { ensureFile, ensureSymlink } from "#shared/src/fs.ts"
import { replaceZshenvVar } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const homebrewZshConfigLink = {
  src: join(__dirname, "zshrc.d", "homebrew.sh"),
  dst: join(zshAutorunDir, "homebrew.sh"),
}

const homebrewUpdateRate = `43200`

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await ensureFile(zshenv)
  await brewBundle(import.meta.dirname)
  await replaceZshenvVar("HOMEBREW_AUTO_UPDATE_SECS", homebrewUpdateRate)
  await ensureSymlink(homebrewZshConfigLink) // add mac specific call to setup homebrew path
  await sharedPrereqsSetup()
}

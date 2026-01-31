import { brewBundle } from "#mac/mac-util.ts"
import sharedPrereqsSetup from "#shared/modules/prereqs/setup.ts"
import { zshenv } from "#shared/src/constants.ts"
import { ensureFile } from "#shared/src/fs.ts"
import { addLineToZshenv } from "#shared/src/util.ts"

const homebrewUpdateRate = `export HOMEBREW_AUTO_UPDATE_SECS=43200`

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await ensureFile(zshenv)
  await brewBundle(import.meta.dirname)
  await addLineToZshenv(homebrewUpdateRate)
  await sharedPrereqsSetup()
}

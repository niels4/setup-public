import { brewBundle } from "#mac/mac-util.ts"
import { zshenv } from "#shared/constants.ts"
import sharedPrereqsSetup from "#shared/modules/prereqs/setup.ts"
import { addLineToZshenv } from "#shared/util.ts"
import fs from "fs-extra"

const homebrewUpdateRate = `export HOMEBREW_AUTO_UPDATE_SECS=43200`
const homebrewEnv = `eval "$(/opt/homebrew/bin/brew shellenv)"`

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await fs.ensureFile(zshenv)
  await addLineToZshenv(homebrewUpdateRate)
  await addLineToZshenv(homebrewEnv)
  await brewBundle(import.meta.dirname)
  await sharedPrereqsSetup()
}

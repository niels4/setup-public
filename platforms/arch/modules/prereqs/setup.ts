import { pacman } from "#arch/arch-util.ts"
import sharedPrereqsSetup from "#shared/modules/prereqs/setup.ts"
import { zshenv } from "#shared/src/constants.ts"
import fs from "fs-extra"

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await fs.ensureFile(zshenv)
  await pacman("ripgrep expect")
  await sharedPrereqsSetup()
}

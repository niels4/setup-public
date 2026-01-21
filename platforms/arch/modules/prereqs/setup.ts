import { pacman } from "#arch/arch-util.ts"
import sharedPrereqsSetup from "#shared/modules/prereqs/setup.ts"
import { zshenv } from "#shared/src/constants.ts"
import { ensureFile } from "#shared/src/fs.ts"
import { shell } from "#shared/src/util.ts"

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await ensureFile(zshenv)
  await pacman("ripgrep expect")
  await shell("cargo default stable")
  await sharedPrereqsSetup()
}

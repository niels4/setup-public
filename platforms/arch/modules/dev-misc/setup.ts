import { aur, pacman } from "#arch/arch-util.ts"
import sharedDevMiscSetup from "#shared/modules/dev-misc/setup.ts"

export default async function setup() {
  await pacman("direnv")
  await aur("shellcheck-bin")
  await sharedDevMiscSetup()
}

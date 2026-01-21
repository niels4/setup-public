import { aur } from "#arch/arch-util.ts"
import sharedDevMiscSetup from "#shared/modules/dev-misc/setup.ts"

export default async function setup() {
  aur("shellcheck-bin ltex-ls-plus-bin")
  await sharedDevMiscSetup()
}

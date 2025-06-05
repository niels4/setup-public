import { pacman } from "#arch/arch-util.ts"
import sharedGitSetup from "#shared/modules/git/setup.ts"

export default async function setup() {
  // git already installed in setup.sh
  await pacman("lazygit")
  await sharedGitSetup()
}

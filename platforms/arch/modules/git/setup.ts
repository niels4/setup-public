import { pacman } from "#arch/arch-util.ts"
import sharedGitSetup from "#shared/modules/git/setup.ts"

export default async function setup() {
  // git already installed in platforms/arch/setup.sh
  await pacman("git-lfs lazygit")
  await sharedGitSetup()
}

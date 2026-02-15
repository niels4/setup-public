import { pacman } from "#arch/arch-util.ts"
import sharedDevContainerSetup from "#shared/modules/linux-dev-container/setup.ts"

export default async function setup() {
  await pacman("podman")
  await sharedDevContainerSetup()
}

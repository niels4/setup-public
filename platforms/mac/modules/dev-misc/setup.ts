import { brewBundle } from "#mac/mac-util.ts"
import sharedDevMiscSetup from "#shared/modules/dev-misc/setup.ts"

export default async function setup() {
  await brewBundle(import.meta.dirname)
  await sharedDevMiscSetup()
}

import { brewBundle } from "#mac/mac-util.ts"
import sharedShellSetup from "#shared/modules/shell/setup.ts"

export default async function setup() {
  await brewBundle(import.meta.dirname)
  await sharedShellSetup()
}

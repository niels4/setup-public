import { brewBundle } from "#mac/mac-util.ts"
import sharedGitSetup from "#shared/modules/git/setup.ts"

export default async function setup() {
  await brewBundle(import.meta.dirname)
  await sharedGitSetup()
}

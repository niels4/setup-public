import { brewBundle } from "#mac/mac-util.ts"
import sharedPythonSetup from "#shared/modules/python/setup.ts"

export default async function setup() {
  await brewBundle(import.meta.dirname)
  await sharedPythonSetup()
}

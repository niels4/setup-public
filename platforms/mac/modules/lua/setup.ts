import { brewBundle } from "#mac/mac-util.ts"
import sharedLuaSetup from "#shared/modules/lua/setup.ts"

export default async function setup() {
  brewBundle(import.meta.dirname)
  await sharedLuaSetup()
}

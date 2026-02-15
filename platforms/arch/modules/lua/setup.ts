import { pacman } from "#arch/arch-util.ts"
import sharedLuaSetup from "#shared/modules/lua/setup.ts"

export default async function setup() {
  await pacman("luajit")
  await sharedLuaSetup()
}

import { join } from "node:path"
import { shell } from "#shared/src/util.ts"

export const brewBundle = async (dir: string) => {
  const brewfile = join(dir, "Brewfile")
  await shell(`brew bundle --file=${brewfile}`)
}

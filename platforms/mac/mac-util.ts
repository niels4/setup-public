import { shell } from "#shared/src/util.ts"
import { join } from "node:path"

export const brewBundle = async (dir: string) => {
  const brewfile = join(dir, "Brewfile")
  await shell(`brew bundle --file=${brewfile}`)
}

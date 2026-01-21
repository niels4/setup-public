import { join } from "node:path"
import { configHome } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"

const __dirname = import.meta.dirname

const configLink = {
  src: join(__dirname, "config"),
  dst: join(configHome, "git", "config"),
}

export default async function setup() {
  await ensureSymlink(configLink)
}

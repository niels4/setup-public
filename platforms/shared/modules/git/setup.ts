import { configHome } from "#shared/constants.ts"
import { replaceFileWithLink } from "#shared/util.ts"
import { join } from "path"

const __dirname = import.meta.dirname

const configLink = {
  src: join(__dirname, "config"),
  dst: join(configHome, "git", "config"),
}

export default async function setup() {
  await replaceFileWithLink(configLink)
}

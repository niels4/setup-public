import { homedir } from "#shared/constants.ts"
import { addLineToZshenv, replaceFileWithLink } from "#shared/util.ts"
import { join } from "path"

const __dirname = import.meta.dirname

const nvimDirLink = {
  src: join(__dirname, "nvim"),
  dst: join(homedir, ".config", "nvim"),
}

export default async function setup() {
  await replaceFileWithLink(nvimDirLink)
  await addLineToZshenv("export EDITOR=nvim")
  await addLineToZshenv("export MANPAGER='nvim +Man!'")
}

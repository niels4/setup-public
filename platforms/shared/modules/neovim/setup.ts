import { join } from "node:path"
import { homedir, zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { npm, replaceZshenvVar } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const nvimDirLink = {
  src: join(__dirname, "nvim"),
  dst: join(homedir, ".config", "nvim"),
}

const nvimZshConfigLink = {
  src: join(__dirname, "zshrc.d", "neovim.sh"),
  dst: join(zshAutorunDir, "neovim.sh"),
}

export default async function setup() {
  await ensureSymlink(nvimDirLink)
  await ensureSymlink(nvimZshConfigLink)
  await replaceZshenvVar("EDITOR", "nvim")
  await replaceZshenvVar("MANPAGER", "'nvim +Man!'")
  await npm("markdownlint-cli")
}

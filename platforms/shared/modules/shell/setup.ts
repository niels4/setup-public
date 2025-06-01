import { configHome, homedir, zdotDir } from "#shared/constants.ts"
import { cmd, replaceFileWithLink } from "#shared/util.ts"
import fs from "fs-extra"
import { join } from "node:path"

const dir = import.meta.dirname

const zinitHome = process.env["ZINIT_HOME"]!

const tmuxConfigLink = {
  src: join(dir, "tmux.conf"),
  dst: join(configHome, "tmux", "tmux.conf"),
}

const zshrcLink = {
  src: join(dir, "zshrc"),
  dst: join(zdotDir, ".zshrc"),
}

const scriptsDirLink = {
  src: join(dir, "scripts"),
  dst: join(homedir, "s"),
}

export default async function setup() {
  await replaceFileWithLink(tmuxConfigLink)
  await replaceFileWithLink(zshrcLink)
  await replaceFileWithLink(scriptsDirLink)

  if (!(await fs.pathExists(zinitHome))) {
    await cmd('git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"')
  }
}

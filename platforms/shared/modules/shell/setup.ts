import { configHome, dataHome, homedir } from "#shared/constants.ts"
import { addLineToZshenv, cmd, replaceFileWithLink } from "#shared/util.ts"
import fs from "fs-extra"
import { join } from "node:path"

const dir = import.meta.dirname

const zinitHome = join(dataHome, "zinit", "zinit.git")
const zdotDirVar = 'export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"'
const zinitHomeVar = `export ZINIT_HOME="${zinitHome}"`

const tmuxConfigLink = {
  src: join(dir, "tmux.conf"),
  dst: join(configHome, "tmux", "tmux.conf"),
}

const zshrcLink = {
  src: join(dir, "zshrc"),
  dst: join(configHome, "zsh", ".zshrc"),
}

const scriptsDirLink = {
  src: join(dir, "scripts"),
  dst: join(homedir, "s"),
}

export default async function setup() {
  await addLineToZshenv(zdotDirVar)
  await addLineToZshenv(zinitHomeVar)
  await replaceFileWithLink(tmuxConfigLink)
  await replaceFileWithLink(zshrcLink)
  await replaceFileWithLink(scriptsDirLink)

  if (!(await fs.pathExists(zinitHome))) {
    await fs.ensureDir(zinitHome)
    await cmd('git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"')
  }
}

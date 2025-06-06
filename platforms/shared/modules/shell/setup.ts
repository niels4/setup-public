import { configHome, homedir, zdotDir, zshAutorunDir } from "#shared/constants.ts"
import { cmd, replaceFileWithLink } from "#shared/util.ts"
import fs from "fs-extra"
import { join } from "node:path"

const __dirname = import.meta.dirname

const zinitHome = process.env["ZINIT_HOME"]!

const tmuxConfigLink = {
  src: join(__dirname, "tmux.conf"),
  dst: join(configHome, "tmux", "tmux.conf"),
}

const zshrcLink = {
  src: join(__dirname, "zshrc"),
  dst: join(zdotDir, ".zshrc"),
}

const scriptsDirLink = {
  src: join(__dirname, "scripts"),
  dst: join(homedir, "s"),
}

const reloadAllZshConfig = {
  src: join(__dirname, "zshrc.d", "reload_all_zsh.sh"),
  dst: join(zshAutorunDir, "reload_all_zsh.sh"),
}

const zshPluginsConfig = {
  src: join(__dirname, "zshrc.d", "plugins.sh"),
  dst: join(zshAutorunDir, "plugins.sh"),
}

export default async function setup() {
  await replaceFileWithLink(tmuxConfigLink)
  await replaceFileWithLink(zshrcLink)
  await replaceFileWithLink(scriptsDirLink)
  await replaceFileWithLink(zshPluginsConfig)
  await replaceFileWithLink(reloadAllZshConfig)

  if (!(await fs.pathExists(zinitHome))) {
    await cmd('git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"')
  }
}

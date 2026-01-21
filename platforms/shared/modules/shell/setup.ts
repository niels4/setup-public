import { join } from "node:path"
import { configHome, homedir, zdotDir, zshAutorunDir } from "#shared/src/constants.ts"
import { checkPathExists, ensureSymlink } from "#shared/src/fs.ts"
import { shell } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const zinitHome = process.env.ZINIT_HOME

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
  await ensureSymlink(tmuxConfigLink)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(scriptsDirLink)
  await ensureSymlink(zshPluginsConfig)
  await ensureSymlink(reloadAllZshConfig)

  if (!(await checkPathExists(zinitHome))) {
    await shell('git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"')
  }
}

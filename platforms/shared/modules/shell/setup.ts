import { join } from "node:path"
import { configHome, dataHome, homedir, zdotDir, zshAutorunDir } from "#shared/src/constants.ts"
import { checkPathExists, ensureSymlink } from "#shared/src/fs.ts"
import { shell } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const zshPluginDir = join(dataHome, "zsh", "plugins")

const plugins = [
  ["zsh-completions", "zsh-users/zsh-completions"],
  ["zsh-syntax-highlighting", "zsh-users/zsh-syntax-highlighting"],
  ["zsh-autosuggestions", "zsh-users/zsh-autosuggestions"],
] as const

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

const pluginsLink = {
  src: join(__dirname, "plugins.sh"),
  dst: join(zdotDir, "plugins.sh"),
}

const completionsLink = {
  src: join(__dirname, "completions.sh"),
  dst: join(zdotDir, "completions.sh"),
}

const zshBaseLink = {
  src: join(__dirname, "zsh-base.sh"),
  dst: join(zdotDir, "zsh-base.sh"),
}

const toolsLink = {
  src: join(__dirname, "tools.sh"),
  dst: join(zdotDir, "tools.sh"),
}

const reloadAllZshConfig = {
  src: join(__dirname, "zshrc.d", "reload_all_zsh.sh"),
  dst: join(zshAutorunDir, "reload_all_zsh.sh"),
}

export default async function setup() {
  await ensureSymlink(tmuxConfigLink)
  await ensureSymlink(pluginsLink)
  await ensureSymlink(completionsLink)
  await ensureSymlink(zshBaseLink)
  await ensureSymlink(toolsLink)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(scriptsDirLink)
  await ensureSymlink(reloadAllZshConfig)

  for (const [name, repo] of plugins) {
    const pluginPath = join(zshPluginDir, name)
    if (!(await checkPathExists(pluginPath))) {
      await shell(`git clone https://github.com/${repo}.git "${pluginPath}"`)
    }
  }
}

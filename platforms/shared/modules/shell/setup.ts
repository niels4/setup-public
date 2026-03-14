import { userInfo } from "node:os"
import { join } from "node:path"
import { configHome, dataHome, homedir, zdotDir, zshAutorunDir } from "#shared/src/constants.ts"
import { checkPathExists, ensureDir, ensureSymlink } from "#shared/src/fs.ts"
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

const includesDir = join(__dirname, "includes")
const zshIncludesDir = join(zdotDir, "includes")

const pluginsLink = {
  src: join(includesDir, "plugins.sh"),
  dst: join(zshIncludesDir, "plugins.sh"),
}

const completionsLink = {
  src: join(includesDir, "completions.sh"),
  dst: join(zshIncludesDir, "completions.sh"),
}

const zshBaseLink = {
  src: join(includesDir, "zsh-base.sh"),
  dst: join(zshIncludesDir, "zsh-base.sh"),
}

const toolsLink = {
  src: join(includesDir, "tools.sh"),
  dst: join(zshIncludesDir, "tools.sh"),
}

export default async function setup() {
  if (userInfo().shell !== "/bin/zsh") {
    await shell(`chsh -s /bin/zsh`)
  }

  await ensureDir(zshAutorunDir)
  await ensureSymlink(tmuxConfigLink)
  await ensureSymlink(pluginsLink)
  await ensureSymlink(completionsLink)
  await ensureSymlink(zshBaseLink)
  await ensureSymlink(toolsLink)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(scriptsDirLink)

  for (const [name, repo] of plugins) {
    const pluginPath = join(zshPluginDir, name)
    if (!(await checkPathExists(pluginPath))) {
      await shell(`git clone https://github.com/${repo}.git "${pluginPath}"`)
    }
  }
}

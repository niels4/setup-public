import { join } from "node:path"
import sharedShellSetup from "#shared/modules/shell/setup.ts"
import { configHome, zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"

const __dirname = import.meta.dirname


const devShellZshLink = {
  src: join(__dirname, "zshrc.d", "container-shell.sh"),
  dst: join(zshAutorunDir, "container-shell.sh"),
}

const tealdeerConfigDir = join(configHome, "tealdeer")

const tealdeerConfigLink = {
  src: join(__dirname, "tealeer", "config.toml"),
  dst: join(tealdeerConfigDir, "config.toml"),
}

export default async function setup() {
  await ensureSymlink(tealdeerConfigLink)
  await sharedShellSetup()
  await ensureSymlink(devShellZshLink) // add container specific aliases and scripts
}

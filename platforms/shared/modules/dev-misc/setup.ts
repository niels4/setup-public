import { join } from "node:path"
import { zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { shell } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const devMiscZshConfigLink = {
  src: join(__dirname, "zshrc.d", "dev-misc.sh"),
  dst: join(zshAutorunDir, "dev-misc.sh"),
}

export default async function setup() {
  await shell("npm install -g bash-language-server yaml-language-server")
  await shell("cargo install taplo-cli")
  await ensureSymlink(devMiscZshConfigLink) // setup direnv
}

import { join } from "node:path"
import { setupDirVar, setupRoot, sharedDir, zdotDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { addLineToZshenv, replaceZshenvVar, shell, shellIsSuccessful } from "#shared/src/util.ts"

const nodeVersion = process.env.NODE_VERSION

const baseVarsDst = join(zdotDir, "base-vars.sh")
const sourceBaseVars = `source "${baseVarsDst}"`

const baseVarsLink = {
  src: join(sharedDir, "base-vars.sh"),
  dst: baseVarsDst,
}

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await ensureSymlink(baseVarsLink)
  await addLineToZshenv(sourceBaseVars)
  await replaceZshenvVar(setupDirVar, setupRoot)

  if (!(await shellIsSuccessful("which cargo"))) {
    await shell("rustup-init -y --no-modify-path")
  }

  await shell("rustup update")

  if (nodeVersion) {
    await shell(`fnm use ${nodeVersion}`)
  } else {
    await shell("fnm use latest")
  }
}

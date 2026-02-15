import { join } from "node:path"
import {
  configHome,
  defaultNpmPackagesFile,
  devDir,
  devDirVar,
  setupDirVar,
  setupRoot,
  sharedDir,
  zdotDir,
} from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { addLineToZshenv, replaceZshenvVar, shell, shellIsSuccessful } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const defaultNpmPackagesLink = {
  src: join(__dirname, "default-npm-packages"),
  dst: join(defaultNpmPackagesFile),
}

const miseConfigLink = {
  src: join(__dirname, "mise_config.toml"),
  dst: join(configHome, "mise", "config.toml"),
}

const baseVarsDst = join(zdotDir, "base-vars.sh")
const sourceBaseVars = `. "${baseVarsDst}"`

const baseVarsLink = {
  src: join(sharedDir, "base-vars.sh"),
  dst: baseVarsDst,
}

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await ensureSymlink(defaultNpmPackagesLink)
  await ensureSymlink(baseVarsLink)
  await ensureSymlink(miseConfigLink)
  await addLineToZshenv(sourceBaseVars)
  await replaceZshenvVar(setupDirVar, setupRoot)
  await replaceZshenvVar(devDirVar, devDir)

  if (!(await shellIsSuccessful("cargo --version"))) {
    await shell("rustup default stable")
  } else {
    await shell("rustup update")
  }
}

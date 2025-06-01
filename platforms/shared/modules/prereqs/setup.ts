import { sharedDir, zdotDir } from "#shared/constants.ts"
import { addLineToZshenv, replaceFileWithLink } from "#shared/util.ts"
import { join } from "node:path"

const baseVarsDst = join(zdotDir, "base-vars.sh")
const sourceBaseVars = `source "${baseVarsDst}"`
const fnmEnv = 'eval "$(fnm env --use-on-cd)"'

const baseVarsLink = {
  src: join(sharedDir, "base-vars.sh"),
  dst: baseVarsDst,
}

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await replaceFileWithLink(baseVarsLink)
  await addLineToZshenv(sourceBaseVars)
  await addLineToZshenv(fnmEnv)
}

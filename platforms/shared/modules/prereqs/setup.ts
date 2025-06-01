import { configHome, dataHome } from "#shared/constants.ts"
import { addLineToZshenv } from "#shared/util.ts"

const configDir = `export XDG_CONFIG_HOME="${configHome}"`
const dataDir = `export XDG_DATA_HOME="${dataHome}"`
const cacheDir = 'export XDG_CACHE_HOME="${HOME}/.cache"'
const fnmEnv = 'eval "$(fnm env --use-on-cd)"'
const goPath = 'export PATH="${HOME}"/go/bin:${PATH}'
const nodePath = 'export PATH="./node_modules/.bin:${PATH}"'
const cargoHome = 'export CARGO_HOME="$XDG_DATA_HOME/cargo"'
const rustupHome = 'export RUSTUP_HOME="$XDG_CONFIG_HOME/rustup"'
const rustPath = 'export PATH="${CARGO_HOME}/bin:${PATH}"'

// Add required utilities and environment variables that all scripts can rely on
export default async function setup() {
  await addLineToZshenv(configDir)
  await addLineToZshenv(dataDir)
  await addLineToZshenv(cacheDir)
  await addLineToZshenv(fnmEnv)
  await addLineToZshenv(goPath)
  await addLineToZshenv(nodePath)
  await addLineToZshenv(cargoHome)
  await addLineToZshenv(rustupHome)
  await addLineToZshenv(rustPath)
}

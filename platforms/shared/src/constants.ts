import { hostname, userInfo } from "node:os"
import { join } from "node:path"
const env = process.env

if (!env.XDG_DATA_HOME || !env.XDG_CONFIG_HOME || !env.ZDOTDIR) {
  throw new Error("Did you forget to source the base-vars?")
}

export const setupEnvVar = "SETUP_ENV"
export const setupModuleVar = "SETUP_MODULE"
export const setupDirVar = "SETUP_DIR"
export const devContainerHomeVar = "DEV_CONTAINER_HOME"

export const sharedDir = join(import.meta.dirname, "..")
export const platformsDir = join(sharedDir, "..")
export const setupRoot = join(platformsDir, "..")

export const host = hostname()
export const { homedir, username } = userInfo()
export const zshenv = join(homedir, ".zshenv")
export const dataHome = env.XDG_DATA_HOME!
export const configHome = env.XDG_CONFIG_HOME!
export const zdotDir = env.ZDOTDIR!
export const zshAutorunDir = join(zdotDir, "zshrc.d")
export const defaultNpmPackagesFile = env.MISE_NODE_DEFAULT_PACKAGES_FILE!

export const red = "\u{001B}[31m"
export const green = "\u{001B}[32m"
export const bold = "\u{001B}[1m"
export const reset = "\u{001B}[0m"
export const checkmark = "✓"

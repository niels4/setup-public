import { hostname, userInfo } from "node:os"
import { join } from "node:path"

export const setupEnvVar = "SETUP_ENV"

const sharedDir = import.meta.dirname
export const setupRoot = join(sharedDir, "..", "..")

export const host = hostname()
export const { homedir, username } = userInfo()
export const dataHome = join(homedir, ".local", "share")
export const configHome = join(homedir, ".config")
export const zshenv = join(homedir, ".zshenv")

export const red = "\u{001B}[31m"
export const green = "\u{001B}[32m"
export const bold = "\u{001B}[1m"
export const reset = "\u{001B}[0m"
export const checkmark = "✓"

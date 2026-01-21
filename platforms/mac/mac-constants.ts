import { join } from "node:path"
import { homedir } from "#shared/src/constants.ts"

export const libraryDir = join(homedir, "Library")
export const preferencesDir = join(libraryDir, "Preferences")

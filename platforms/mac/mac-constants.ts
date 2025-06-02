import { homedir } from "#shared/constants.ts"
import { join } from "path"

export const libraryDir = join(homedir, "Library")
export const preferencesDir = join(libraryDir, "Preferences")

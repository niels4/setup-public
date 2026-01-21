import { join } from "node:path"
import { brewBundle } from "#mac/mac-util.ts"
import { homedir } from "#shared/src/constants.ts"
import { copy_rf } from "#shared/src/fs.ts"

const profilesFile = "Profiles.json"
const __dirname = import.meta.dirname

const dynamicProfilesDir = join(homedir, "Library", "Application Support", "iTerm2", "DynamicProfiles")

const iterm2ProfilesLink = {
  src: join(__dirname, profilesFile),
  dst: join(dynamicProfilesDir, profilesFile),
}

export default async function setup() {
  await brewBundle(__dirname)
  await copy_rf(iterm2ProfilesLink)
}

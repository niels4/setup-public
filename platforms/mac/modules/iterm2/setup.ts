import { preferencesDir } from "#mac/mac-constants.ts"
import { brewBundle } from "#mac/mac-util.ts"
import { replaceFile } from "#shared/util.ts"
import { join } from "node:path"

const plistFile = "com.googlecode.iterm2.plist"
const __dirname = import.meta.dirname

const iterm2PlistLink = {
  src: join(__dirname, plistFile),
  dst: join(preferencesDir, plistFile),
}

export default async function setup() {
  await brewBundle(__dirname)
  await replaceFile(iterm2PlistLink)
}

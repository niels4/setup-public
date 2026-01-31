import { join } from "node:path"
import { brewBundle } from "#mac/mac-util.ts"
import { zshAutorunDir } from "#shared/src/constants.ts"
import { ensureSymlink } from "#shared/src/fs.ts"
import { shell, shellIsSuccessful } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const swiftZshConfigLink = {
  src: join(__dirname, "zshrc.d", "swift.sh"),
  dst: join(zshAutorunDir, "swift.sh"),
}

export default async function setup() {
  await brewBundle(import.meta.dirname)

  await ensureSymlink(swiftZshConfigLink) // needed for swiftly

  try {
    await shell(`. ${swiftZshConfigLink.dst}; swiftly init -y --no-modify-profile`)
  } catch {
    console.log("swiftly install latest failed, trying once more")
  }
  // if this still fails, try running 'swiftly install latest' in the shell manually
  await shell(`. ${swiftZshConfigLink.dst}; swiftly install latest`)

  // install latest version of xcode with 'xcodes install --latest'

  // once this installs you will need to manually run the following command to get swiftlint to work
  // replace <version> with the latest installed Xcode version

  // 'sudo xcode-select /Applications/Xcode-<version>.app/'

  const installedXcodes = await shell("xcodes installed")
  const xcodeInstalled = installedXcodes.includes("Xcode")
  const swiftlintInstalled = await shellIsSuccessful("which swiftlint")
  if (xcodeInstalled && !swiftlintInstalled) {
    // only install swiftlint if xcode has been installed
    await shell("brew install swiftlint")
  }
}

import { join } from "node:path"
import sharedDevContainerSetup from "#shared/modules/dev-container/setup.ts"
import { shell, shellIsSuccessful } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const shellFunctionsFile = join(__dirname, "zshrc.d", "dev-container.sh")
const sshConfigFile = join(__dirname, "ssh-config.d", "dev-container.conf")

export default async function setup() {
  // install rosetta if its not already installed
  if (!(await shellIsSuccessful("pgrep -q oahd"))) {
    await shell("softwareupdate --install-rosetta --agree-to-license")
  }
  await sharedDevContainerSetup({ shellFunctionsFile, sshConfigFile })
}

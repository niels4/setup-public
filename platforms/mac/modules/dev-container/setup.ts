import { join, relative } from "node:path"
import { brewBundle } from "#mac/mac-util.ts"
import {
  devContainerHome,
  devContainerHomeVar,
  homedir,
  platformsDir,
  zshAutorunDir,
} from "#shared/src/constants.ts"
import { copy_rf, ensureSymlink } from "#shared/src/fs.ts"
import { replaceZshenvVar, shell, shellIsSuccessful } from "#shared/src/util.ts"

const __dirname = import.meta.dirname

const setupDockerFile = join(platformsDir, "container", "Dockerfile") // use the Dockerfile from the dev-container directory
const dockerFileSrc = relative(devContainerHome, setupDockerFile) // use relative path here so that the symlink works both in host and container
const containerDockerFile = join(devContainerHome, "Dockerfile")

const dockerFileLink = {
  src: dockerFileSrc,
  dst: containerDockerFile,
}

const zshrcLink = {
  src: join(__dirname, "zshrc.d", "dev-container.sh"),
  dst: join(zshAutorunDir, "dev-container.sh"),
}

const sshConfigLink = {
  src: join(__dirname, "ssh-config.d", "dev-container.conf"),
  dst: join(homedir, ".ssh", "config.d", "dev-container.conf"),
}

const authorizedKeysCopy = {
  src: join(homedir, ".ssh", "id_mykey.pub"),
  dst: join(devContainerHome, ".ssh", "authorized_keys"),
}

export default async function setup() {
  await replaceZshenvVar(devContainerHomeVar, devContainerHome)
  await brewBundle(import.meta.dirname)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(dockerFileLink)
  await ensureSymlink(sshConfigLink)
  await copy_rf(authorizedKeysCopy)
  // install rosetta if its not already installed
  if (!(await shellIsSuccessful("pgrep -q oahd"))) {
    await shell("softwareupdate --install-rosetta --agree-to-license")
  }
}

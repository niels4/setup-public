import { join } from "node:path"
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

// reference the relative symlink this way so it works in both the host and the container
const dockerfileLink = {
  src: "./setup/platforms/container/Dockerfile",
  dst: join(devContainerHome, "Dockerfile"),
}

// symlink works in host, gets replaced by actual setup dir when container is run
const setupDirLink = {
  src: join(platformsDir, 'container', 'Dockerfile'),
  dst: join(devContainerHome, "setup", "platforms", "container", "Dockerfile"),
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
  await brewBundle(import.meta.dirname)
  await replaceZshenvVar(devContainerHomeVar, devContainerHome)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(sshConfigLink)
  await ensureSymlink(dockerfileLink)
  await ensureSymlink(setupDirLink)
  await copy_rf(authorizedKeysCopy)
  // install rosetta if its not already installed
  if (!(await shellIsSuccessful("pgrep -q oahd"))) {
    await shell("softwareupdate --install-rosetta --agree-to-license")
  }
}

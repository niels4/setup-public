import { join } from "node:path"
import {
  devContainerHomeVar,
  homedir,
  platformsDir,
  zshAutorunDir,
} from "#shared/src/constants.ts"
import { copy_rf, ensureSymlink } from "#shared/src/fs.ts"
import { replaceZshenvVar } from "#shared/src/util.ts"

const __dirname = import.meta.dirname
const devContainerHome = join(homedir, "containers", "dev")

const podmanConfig: DevContainerOptions = {
  shellFunctionsFile: join(__dirname, "zshrc.d", "dev-container.sh"),
  sshConfigFile: join(homedir, ".ssh", "config.d", "dev-container.conf"),
}

// reference the relative symlink this way so it works in both the host and the container
const dockerfileLink = {
  src: "./setup/platforms/dev-container/Dockerfile",
  dst: join(devContainerHome, "Dockerfile"),
}

// symlink works in host, gets replaced by actual setup dir when container is run
const setupDirLink = {
  src: join(platformsDir, "dev-container", "Dockerfile"),
  dst: join(devContainerHome, "setup", "platforms", "dev-container", "Dockerfile"),
}

const authorizedKeysCopy = {
  src: join(homedir, ".ssh", "id_mykey.pub"),
  dst: join(devContainerHome, ".ssh", "authorized_keys"),
}

type DevContainerOptions = {
  shellFunctionsFile: string
  sshConfigFile: string
}

// default to podman config, mac setup will override with apple container config
export default async function setup(options: DevContainerOptions = podmanConfig) {
  const zshrcLink = {
    src: options.shellFunctionsFile,
    dst: join(zshAutorunDir, "dev-container.sh"),
  }

  const sshConfigLink = {
    src: options.sshConfigFile,
    dst: join(homedir, ".ssh", "config.d", "dev-container.conf"),
  }

  await replaceZshenvVar(devContainerHomeVar, devContainerHome)
  await ensureSymlink(zshrcLink)
  await ensureSymlink(dockerfileLink)
  await ensureSymlink(setupDirLink)
  await ensureSymlink(sshConfigLink)
  await copy_rf(authorizedKeysCopy)
}

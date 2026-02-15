import { join, relative } from "node:path"
import { devDir, homedir, zshAutorunDir } from "#shared/src/constants.ts"
import { copy_rf, ensureSymlink } from "#shared/src/fs.ts"

const __dirname = import.meta.dirname

const setupDockerFile = join(__dirname, "Dockerfile")
const dockerFileSrc = relative(devDir, setupDockerFile) // use relative path here so that the symlink works both in host and container
const containerDockerFile = join(devDir, "Dockerfile")

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
  dst: join(devDir, ".ssh", "authorized_keys"),
}

export default async function setup() {
  await ensureSymlink(zshrcLink)
  await ensureSymlink(dockerFileLink)
  await ensureSymlink(sshConfigLink)
  await copy_rf(authorizedKeysCopy)
}

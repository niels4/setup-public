import { pacman, saveKeyringValue } from "#arch/arch-util.ts"
import { bold, homedir, host, red, reset, username } from "#shared/constants.ts"
import { cmd, randomHexString, replaceFileWithLink } from "#shared/util.ts"
import fs from "fs-extra"
import { join } from "node:path"
import { read } from "read"

const generatePassphrase = () => randomHexString(50)

const keyName = "id_mykey"
const __dirname = import.meta.dirname
const sshDir = join(homedir, ".ssh")
const keyFile = join(sshDir, keyName)

const sshConfigLink = {
  src: join(__dirname, "config"),
  dst: join(sshDir, "config"),
}

const createSshKey = async () => {
  const passphrase = await generatePassphrase()

  const password = await read({
    prompt: "Enter password to save ssh passphrase to keyring: ",
    silent: true,
    replace: "*",
  })

  const saveResult = await saveKeyringValue({
    key: "ssh passphrase",
    value: passphrase,
    password,
  })

  if (!saveResult) {
    console.error(`${red}${bold}Password Incorrect. Could not unlock keyring!${reset}`)
    process.exit(1)
  }

  await cmd(`ssh-keygen -t ed25519 -C "${username}@${host}" -N ${passphrase} -f ${keyFile}`)
}

export default async function setup() {
  await pacman("gnome-keyring libsecret")

  await cmd("systemctl --user enable --now gcr-ssh-agent.socket")

  await replaceFileWithLink(sshConfigLink)

  const keyExists = await fs.pathExists(keyFile)
  if (!keyExists) {
    await createSshKey()
  }
}

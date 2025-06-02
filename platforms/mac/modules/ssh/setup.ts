import { homedir, host, username } from "#shared/constants.ts"
import { cmd, randomHexString, replaceFileWithLink, runExpect } from "#shared/util.ts"
import fs from "fs-extra"
import { join } from "node:path"

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

  await cmd(`ssh-keygen -t ed25519 -C "${username}@${host}" -N ${passphrase} -f ${keyFile}`)

  const sshAddScript = `
spawn ssh-add --apple-use-keychain ${keyFile}
expect "Enter passphrase"
send -- "${passphrase}\r"
`
  // NOTE: Your computer cannot be locked while this script is running or the passphrase won't get saved into the keychain
  await runExpect(sshAddScript, { prepend: 'eval "$(ssh-agent -s)";' })
}

export default async function setup() {
  await replaceFileWithLink(sshConfigLink)
  await cmd(`chmod 600 ${sshConfigLink.dst}`)

  const keyExists = await fs.pathExists(keyFile)
  if (!keyExists) {
    await createSshKey()
  }
}

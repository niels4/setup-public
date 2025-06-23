import { homedir, host, username, zshAutorunDir } from "#shared/src/constants.ts"
import { checkPathExists, ensureDir, ensureSymlink } from "#shared/src/fs.ts"
import { randomHexString, runExpect, shell } from "#shared/src/util.ts"
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

const sshZshConfigLink = {
  src: join(__dirname, "zshrc.d", "ssh.sh"),
  dst: join(zshAutorunDir, "ssh.sh"),
}

const createSshKey = async () => {
  const passphrase = await generatePassphrase()

  const keygenScript = `
spawn ssh-keygen -t ed25519 -C "${username}@${host}"
expect "Enter file in which to save the key"
send -- "${keyFile}\r"
expect -re {Enter passphrase.*}
send -- "${passphrase}\r"
expect "Enter same passphrase again: "
send -- "${passphrase}\r"
`
  await runExpect(keygenScript)

  const sshAddScript = `
spawn ssh-add --apple-use-keychain ${keyFile}
expect "Enter passphrase"
send -- "${passphrase}\r"
`
  // NOTE: Your computer cannot be locked while this script is running or the passphrase won't get saved into the keychain
  await runExpect(sshAddScript, { prepend: 'eval "$(ssh-agent -s)";' })
}

export default async function setup() {
  await ensureSymlink(sshConfigLink)
  await ensureSymlink(sshZshConfigLink)
  await shell(`chmod 600 ${sshConfigLink.dst}`)
  await ensureDir(join(sshDir, "config.d"))

  const keyExists = await checkPathExists(keyFile)
  if (!keyExists) {
    await createSshKey()
  }
}

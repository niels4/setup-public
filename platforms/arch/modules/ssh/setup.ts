import { pacman, savePassSecret } from "#arch/arch-util.ts"
import { dataHome, homedir, host, username, zshAutorunDir } from "#shared/src/constants.ts"
import {
  addLineToZshenv,
  cmd,
  cmdIsSuccessful,
  randomHexString,
  readUserPassword,
  replaceFileWithLink,
  runExpect,
} from "#shared/src/util.ts"
import fs from "fs-extra"
import { join } from "node:path"

const generatePassphrase = () => randomHexString(50)

const sshKeyName = "id_mykey"
const __dirname = import.meta.dirname
const sshDir = join(homedir, ".ssh")
const sshConfigD = join(sshDir, "config.d")
const sshKeyFile = join(sshDir, sshKeyName)

const gpgDir = join(dataHome, "gnupg")
const gpgKeyId = `${username}@${host}`

const passStoreDir = join(dataHome, "password-store")
const passStoreInitFile = join(passStoreDir, ".gpg-id")
const passStoreShhKey = "ssh/passphrase"

const sshConfigLink = {
  src: join(__dirname, "config"),
  dst: join(sshDir, "config"),
}

const sshZshConfigLink = {
  src: join(__dirname, "zshrc.d", "ssh.sh"),
  dst: join(zshAutorunDir, "ssh.sh"),
}

const initGpg = async () => {
  await fs.ensureDir(gpgDir)
  await cmd(`chmod 700 ${gpgDir}`)
  if (await cmdIsSuccessful(`gpg --list-keys ${gpgKeyId}`)) {
    return
  }

  // use user's password as default password for password-store.
  // if you want to use a password that is different than your user password, use the
  // change-password-store-password alias defined in ./zshrc.d/ssh.sh
  const passphrase = await readUserPassword("Enter password to save ssh passphrase to keyring: ")

  await cmd("gpg --batch --generate-key", {
    inputs: [
      "Key-Type: eddsa\n",
      "Key-Curve: ed25519\n",
      "Subkey-Type: ecdh\n",
      "Subkey-Curve: cv25519\n",
      `Name-Real: ${username}\n`,
      `Name-Email: ${gpgKeyId}\n`,
      "Expire-Date: 0\n",
      `Passphrase: ${passphrase}\n`,
      "%commit\n",
    ],
  })
}

const initPass = async () => {
  if (await fs.pathExists(passStoreInitFile)) {
    return
  }
  await cmd(`pass init ${gpgKeyId}`)
}

const initSshKey = async () => {
  if (await fs.pathExists(sshKeyFile)) {
    return
  }
  const passphrase = await generatePassphrase()

  await savePassSecret(passStoreShhKey, passphrase)

  const keygenScript = `
spawn ssh-keygen -t ed25519 -C "${username}@${host}"
expect "Enter file in which to save the key"
send -- "${sshKeyFile}\r"
expect -re {Enter passphrase.*}
send -- "${passphrase}\r"
expect "Enter same passphrase again: "
send -- "${passphrase}\r"
`
  await runExpect(keygenScript)
}

export default async function setup() {
  await addLineToZshenv("export GNUPGHOME=$XDG_DATA_HOME/gnupg")
  await addLineToZshenv("export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store")

  await pacman("pass keychain")

  await replaceFileWithLink(sshZshConfigLink)
  await replaceFileWithLink(sshConfigLink)
  await cmd(`chmod 600 ${sshConfigLink.dst}`)
  await fs.ensureDir(sshConfigD)
  await cmd(`chmod 700 ${sshConfigD}`)

  await initGpg()
  await initPass()
  await initSshKey()
}

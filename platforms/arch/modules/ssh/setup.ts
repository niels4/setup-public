import { join } from "node:path"
import { pacman, savePassSecret } from "#arch/arch-util.ts"
import { dataHome, homedir, host, username, zshAutorunDir } from "#shared/src/constants.ts"
import { checkPathExists, ensureDir, ensureSymlink } from "#shared/src/fs.ts"
import {
  addLineToZshenv,
  randomHexString,
  readUserPassword,
  runExpect,
  shell,
  shellIsSuccessful,
} from "#shared/src/util.ts"

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
  await ensureDir(gpgDir)
  await shell(`chmod 700 ${gpgDir}`)
  if (await shellIsSuccessful(`gpg --list-keys ${gpgKeyId}`)) {
    return
  }

  // use user's password as default password for password-store.
  // if you want to use a password that is different than your user password, use the
  // change-password-store-password alias defined in ./zshrc.d/ssh.sh
  const passphrase = await readUserPassword("Enter password to save ssh passphrase to keyring: ")

  await shell("gpg --batch --generate-key", {
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
  if (await checkPathExists(passStoreInitFile)) {
    return
  }
  await shell(`pass init ${gpgKeyId}`)
}

const initSshKey = async () => {
  if (await checkPathExists(sshKeyFile)) {
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

  await ensureSymlink(sshZshConfigLink)
  await ensureSymlink(sshConfigLink)
  await shell(`chmod 600 ${sshConfigLink.dst}`)
  await ensureDir(sshConfigD)
  await shell(`chmod 700 ${sshConfigD}`)

  await initGpg()
  await initPass()
  await initSshKey()
}

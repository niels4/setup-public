import { pacman } from "#arch/arch-util.ts"
import sharedLinuxSshSetup from "#shared/modules/linux-ssh/setup.ts"
import { replaceZshenvVar } from "#shared/src/util.ts"

export default async function setup() {
  await replaceZshenvVar("GNUPGHOME", "$XDG_DATA_HOME/gnupg")
  await replaceZshenvVar("PASSWORD_STORE_DIR", "$XDG_DATA_HOME/password-store")
  await pacman("pass keychain")
  await sharedLinuxSshSetup({ mirrorUserPassword: true })
}

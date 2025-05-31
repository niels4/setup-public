import { cmd } from "#shared/util.ts"

export const pacman = (packages: string) => {
  return cmd(`sudo pacman --needed --noconfirm -S ${packages}`)
}

export const aur = (packages: string) => {
  return cmd(`yay --needed --noconfirm -S ${packages}`)
}

const unlockKeyring = (password: string) => {
  return cmd("gnome-keyring-daemon -r --unlock", { inputs: [password] })
}

const lockKeyringCmd = `
dbus-send --session --dest=org.freedesktop.secrets \
  --type=method_call  \
  /org/freedesktop/secrets \
  org.freedesktop.Secret.Service.Lock \
  array:objpath:/org/freedesktop/secrets/collection/login
`.trim()

const lockKeyring = () => {
  return cmd(lockKeyringCmd)
}

type SaveKeyringValueProps = {
  label?: string
  key: string
  value: string
  password: string
}

export const saveKeyringValue = async ({
  label,
  key,
  value,
  password,
}: SaveKeyringValueProps): Promise<boolean> => {
  await unlockKeyring(password)
  let result = true
  try {
    await cmd(`secret-tool store --label="${label || key}" ${key}`, { inputs: [value] })
  } catch {
    result = false
  }
  await lockKeyring()
  return result
}

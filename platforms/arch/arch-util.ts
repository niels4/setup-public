import { cmd } from "#shared/util.ts"

export const pacman = (packages: string) => {
  return cmd(`sudo pacman --needed --noconfirm -S ${packages}`)
}

export const aur = (packages: string) => {
  return cmd(`yay --needed --noconfirm -S ${packages}`)
}

export const savePassSecret = async (key: string, secret: string) => {
  await cmd(`pass insert -m -f ${key} <<< "${secret}"`)
}

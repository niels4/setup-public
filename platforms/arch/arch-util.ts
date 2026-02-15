import { shell } from "#shared/src/util.ts"

export const pacman = (packages: string) => {
  return shell(`sudo pacman --needed --noconfirm -S ${packages}`)
}

export const aur = (packages: string) => {
  return shell(`paru --needed --noconfirm -S ${packages}`)
}

export const savePassSecret = async (key: string, secret: string) => {
  await shell(`pass insert -m -f ${key} <<< "${secret}"`)
}

import { pacman } from "#arch/arch-util.ts"
import { shell } from "#shared/src/util.ts"

const packages = ["luajit", "stylua", "lua-language-server", "emmylua_ls"]

export default async function setup() {
  const promises = []

  promises.push(pacman(packages.join(" ")))
  promises.push(shell("cargo install emmylua_ls emmylua_doc_cli emmylua_check --locked"))

  await Promise.all(promises)
}

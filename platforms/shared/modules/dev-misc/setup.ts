import { shell } from "#shared/src/util.ts"

export default async function setup() {
  await shell("npm install -g bash-language-server yaml-language-server")
  await shell("cargo install taplo-cli")
}

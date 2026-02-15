import { npm, shell } from "#shared/src/util.ts"

export default async function setup() {
  await npm("@johnnymorganz/stylua-bin") // formatter
  await shell("mise use -g aqua:LuaLS/lua-language-server") // experiment with using mise and aqua to install lua_ls binary

  // an alternative lua language server and checker, takes a while to install so i leave it commented out by default
  // await shell("cargo install emmylua_ls emmylua_doc_cli emmylua_check --locked")
}

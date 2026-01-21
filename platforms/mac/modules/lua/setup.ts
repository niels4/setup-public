import { brewBundle } from "#mac/mac-util.ts"
import { shell } from "#shared/src/util.ts"

export default async function setup() {
  const promises = []

  promises.push(brewBundle(import.meta.dirname))
  promises.push(shell("cargo install emmylua_ls emmylua_doc_cli emmylua_check --locked"))

  await Promise.all(promises)
}

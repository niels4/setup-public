import { brewBundle } from "#mac/mac-util.ts"

export default async function setup() {
  await brewBundle(import.meta.dirname)
}

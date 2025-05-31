import { pacman } from "#arch/arch-util.ts"

export default async function setup() {
  // ripgrep installed by setup
  await pacman("tree fd coreutils jq zoxide")
}

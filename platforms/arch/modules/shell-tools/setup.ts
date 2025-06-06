import { pacman } from "#arch/arch-util.ts"

export default async function setup() {
  // ripgrep installed by setup
  await pacman("less tree fd coreutils jq zoxide bat")
}

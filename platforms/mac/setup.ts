import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "mac"

const devEnvironments: DevEnvironments = {
  default: ["prereqs", "ssh", "shell", "shell-tools", "git", "neovim", "iterm2"],
}

await runSetup({ platform, devEnvironments })

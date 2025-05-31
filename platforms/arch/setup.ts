import { type DevEnvironments, runSetup } from "#shared/runner.ts"

const platform = "arch"

const devEnvironments: DevEnvironments = {
  default: ["prereqs", "ssh", "shell", "shell-tools", "docs", "neovim"],
}

await runSetup({ platform, devEnvironments })

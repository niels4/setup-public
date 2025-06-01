import { type DevEnvironments, runSetup } from "#shared/runner.ts"

const platform = "mac"

const devEnvironments: DevEnvironments = {
  default: ["prereqs", "ssh", "shell", "shell-tools", "neovim"],
}

await runSetup({ platform, devEnvironments })

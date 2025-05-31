import { type DevEnvironments, runSetup } from "#shared/runner.ts"

const platform = "arch"

const devEnvironments: DevEnvironments = {
  default: ["prereqs"],
}

await runSetup({ platform, devEnvironments })

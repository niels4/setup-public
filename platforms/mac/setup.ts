import { type DevEnvironments, runSetup } from "#shared/runner.ts"

const platform = "mac"

const devEnvironments: DevEnvironments = {
  default: ["prereqs"],
}

await runSetup({ platform, devEnvironments })

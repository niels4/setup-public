#!/usr/bin/env node
import { join } from "node:path"
import { bold, checkmark, green, platformsDir, red, reset, setupEnvVar } from "./constants.ts"

const getImportPath = (platform: string, moduleName: string) =>
  join(platformsDir, platform, "modules", moduleName, "setup.ts")

export type SupportedPlatform = "arch" | "mac"

export type DevEnvironments = {
  default: string[] // default dev environment required
  [key: string]: string[]
}

export type RunSetupArgs = {
  platform: SupportedPlatform
  devEnvironments: DevEnvironments
}

export const runSetup = async function ({ platform, devEnvironments }: RunSetupArgs) {
  const setupEnv = process.env[setupEnvVar] ?? "default"
  const modules = devEnvironments[setupEnv]
  if (!modules) {
    console.log(`${red}${bold}Invalid var ${setupEnvVar}: ${setupEnv}${reset}`)
    console.log("Allowed SETUP_ENV values:", Object.keys(devEnvironments).join(", "))
    process.exit(1)
  }

  console.log(`\n${green}Runnning setup for ${bold}${setupEnv}${reset}\n`)
  for (const moduleName of modules) {
    const { default: setupFunction } = await import(getImportPath(platform, moduleName))
    console.log(`\n${green}Starting Module ${bold}${moduleName}${reset}\n`)
    await setupFunction()
    console.log(`\n${green}${checkmark} Finshed Module ${bold}${moduleName}${reset}\n`)
  }
}

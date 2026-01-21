import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "mac"

const defaultModules = [
  "prereqs",
  "ssh",
  "shell",
  "shell-tools",
  "git",
  "neovim",
  "iterm2",
  "shared:webdev",
  "lua",
  "dev-misc",
  "python",
]

// can reference shared modules directly with "shared:" prefix
const extras = [...defaultModules, "shared:extras"]

const devEnvironments: DevEnvironments = {
  default: defaultModules,

  // install extra tools by setting your SETUP_ENV environment variable
  // SETUP_ENV=extras setup
  extras,
}

await runSetup({ platform, devEnvironments })

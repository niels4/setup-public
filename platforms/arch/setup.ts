import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "arch"

// modules can be installed one at a time by setting the SETUP_MODULE env variable
// SETUP_MODULE=python setup

const defaultModules = [
  "prereqs",
  "ssh",
  "shell",
  "shell-tools",
  "git",
  "docs",
  "neovim",
  // can reference shared modules directly with "shared:" prefix
  "shared:webdev",
  "lua",
  "shared:go",
  "dev-misc",
  "python",
  "dev-container",
]

// $SETUP_ENV var determines which set of modules is run
const devEnvironments: DevEnvironments = {
  // default env run when SETUP_ENV is not defined
  default: defaultModules,

  // SETUP_ENV=extras setup
  extras: [
    // extend the default set of modules with extra tools that we may not want installed by every time
    ...defaultModules,
    // optional cli tools
    "shared:extras",
  ],

  // SETUP_ENV=minimal setup
  minimal: ["prereqs", "ssh", "shell", "shell-tools", "git", "docs", "neovim"],
}

await runSetup({ platform, devEnvironments })

// modules can be installed one at a time by setting the SETUP_MODULE env variable
// SETUP_MODULE=swift setup

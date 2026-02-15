import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "container"

// modules can be installed one at a time by setting the SETUP_MODULE env variable
// SETUP_MODULE=shared:extras setup

const defaultModules = [
  // can reference shared modules directly with "shared:" prefix
  "shared:prereqs",
  "shared:linux-ssh",
  "shared:git",
  // setup specific to containers goes in the container modules directory
  "shell",
  "shared:neovim",
  "shared:webdev",
  "shared:dev-misc",
  "shared:python",
  "shared:lua",
  "shared:go",
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
  minimal: ["shared:prereqs", "shared:linux-ssh", "shared:git", "shell", "shared:neovim"],
}

await runSetup({ platform, devEnvironments })

import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "mac"

// modules can be installed one at a time by setting the SETUP_MODULE env variable
// SETUP_MODULE=swift setup

const defaultModules = [
  "prereqs",
  "ssh",
  "shell",
  "shell-tools",
  "git",
  "neovim",
  "iterm2",
  // can reference shared modules directly with "shared:" prefix
  "shared:webdev",
  "lua",
  "shared:go",
  "dev-misc",
  "python",
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
    // install tools for swift development only as an extra
    "swift",
  ],

  // SETUP_ENV=minimal setup
  minimal: ["prereqs", "ssh", "shell", "shell-tools", "git", "neovim"],
}

await runSetup({ platform, devEnvironments })

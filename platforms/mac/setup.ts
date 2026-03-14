import { type DevEnvironments, runSetup } from "#shared/src/runner.ts"

const platform = "mac"

// modules can be installed one at a time by setting the SETUP_MODULE env variable
// SETUP_MODULE=swift setup

const defaultModules = [
  "prereqs",
  "ssh",
  // can reference shared modules directly with "shared:" prefix
  "shared:shell",
  "shared:git",
  "shared:neovim",
  "shared:webdev",
  "shared:lua",
  "shared:go",
  "shared:dev-misc",
  "shared:python",
  "iterm2",
  "dev-container",
]

const workModules = [
  "prereqs",
  "ssh",
  "shared:shell",
  "shared:git",
  "shared:neovim",
  "shared:webdev",
  "shared:lua",
  "shared:go",
  "shared:dev-misc",
  "shared:python",
  "iterm2",
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
    // install tools for swift development only as an extra
    "swift",
  ],

  // SETUP_ENV=minimal setup
  minimal: ["prereqs", "ssh", "shared:shell", "shared:git", "shared:neovim"],

  work: workModules,
}

await runSetup({ platform, devEnvironments })

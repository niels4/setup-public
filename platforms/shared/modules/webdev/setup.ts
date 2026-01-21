import { shell } from "#shared/src/util.ts"

// intall language servers needed for web development

const npmPackages = [
  // typescript and javascript development
  "typescript-language-server",
  // contains eslint and jsonlint
  "vscode-langservers-extracted",
  "corepack",
]

export default async function setup() {
  await shell(`npm install -g ${npmPackages.join(" ")}`)
}

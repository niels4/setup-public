import { shell } from "#shared/src/util.ts"

// intall language servers and tools needed for go development

const goPackages = [
  // language server
  "golang.org/x/tools/gopls@latest",
  // linter
  "honnef.co/go/tools/cmd/staticcheck@latest",
]

export default async function setup() {
  for (const goPackage of goPackages) {
    await shell(`go install ${goPackage}`)
  }
}

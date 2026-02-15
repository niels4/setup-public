import { pacman } from "#arch/arch-util.ts"
import sharedPythonSetup from "#shared/modules/python/setup.ts"

const packages = ["python", "python-pipx"]

export default async function setup() {
  await pacman(packages.join(" "))
  await sharedPythonSetup()
}

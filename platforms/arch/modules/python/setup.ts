import { pacman } from "#arch/arch-util.ts"

const packages = ["python", "python-isort", "python-black", "ruff"]

export default async function setup() {
  await pacman(packages.join(" "))
}

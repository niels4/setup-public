import { pacman } from "#arch/arch-util.ts"

const packages = ["python", "isort", "black", "ruff"]

export default async function setup() {
  await pacman(packages.join(" "))
}

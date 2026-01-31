import { pacman } from "#arch/arch-util.ts"

const packages = ["python", "python-isort", "python-black", "ruff", "python-pipx"]

export default async function setup() {
  await pacman(packages.join(" "))
}

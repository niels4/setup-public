import { npm, shell, shellIsSuccessful } from "#shared/src/util.ts"

export default async function setup() {
  if (!(await shellIsSuccessful("which uv"))) {
    await shell("curl -LsSf https://astral.sh/uv/install.sh | UV_NO_MODIFY_PATH=1 sh")
  }
  await shell("pipx install ruff")
  await shell("pipx install isort")
  await shell("pipx install black")
  npm("pyright")
}

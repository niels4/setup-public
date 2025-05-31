import fs from "fs-extra"
import { spawn } from "node:child_process"
import { zshenv } from "./constants.ts"

export const escapeDoubleQuotes = (str: string) => str.replace(/"/g, `\\"`)
export const escapeDollarSigns = (str: string) => str.replace(/\$/g, `\\$`)

export const cmd = async (cmdStr: string): Promise<string> => {
  cmdStr = `source ${zshenv}; ${cmdStr}`
  const cp = spawn(cmdStr, { shell: true })
  cp.stdout.pipe(process.stdout)
  cp.stderr.pipe(process.stderr)

  let result = ""

  cp.stdout.on("data", (chunk) => {
    result += chunk
  })

  return new Promise((resolve, reject) => {
    cp.on("exit", (code: number) => {
      if (code !== 0) {
        reject(`Child Process exited with error code ${code}`)
        return
      }
      resolve(result.trim())
    })
  })
}

export const replaceFileWithLink = async ({ src, dst }: { src: string; dst: string }) => {
  await fs.remove(dst)
  await fs.ensureSymlink(src, dst)
}

export const fileContainsText = async (file: string, text: string) => {
  const escapedText = escapeDoubleQuotes(escapeDollarSigns(text))
  try {
    await cmd(`rg --fixed-strings "${escapedText}" ${file}`)
    return true
  } catch {
    return false
  }
}

export const addLineToZshenv = async (line: string) => {
  if (!(await fileContainsText(zshenv, line))) {
    const escapedLine = escapeDoubleQuotes(escapeDollarSigns(line))
    await cmd(`echo "${escapedLine}" >> ${zshenv}`)
  }
}

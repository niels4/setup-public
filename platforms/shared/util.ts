import fs from "fs-extra"
import { spawn } from "node:child_process"
import { randomBytes } from "node:crypto"
import { type Stream } from "node:stream"
import { promisify } from "node:util"
import { zshenv } from "./constants.ts"

const randomBytesAsync = promisify(randomBytes)

export const escapeDoubleQuotes = (str: string) => str.replace(/"/g, `\\"`)
export const escapeDollarSigns = (str: string) => str.replace(/\$/g, `\\$`)

const handleInputs = (stdin: Stream.Writable, inputs?: string[]) => {
  if (!inputs || inputs.length === 0) {
    return
  }
  inputs.forEach((input) => {
    stdin.write(input)
  })
  stdin.end()
}

type CmdOptions = {
  inputs?: string[]
}

export const cmd = async (cmdStr: string, options?: CmdOptions): Promise<string> => {
  cmdStr = `source ${zshenv}; ${cmdStr}`
  const cp = spawn(cmdStr, { shell: true })
  cp.stdout.pipe(process.stdout)
  cp.stderr.pipe(process.stderr)
  handleInputs(cp.stdin, options?.inputs)

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

export const randomHexString = async (byteLength: number) => {
  const bytes = await randomBytesAsync(byteLength)
  return bytes.toString("hex")
}

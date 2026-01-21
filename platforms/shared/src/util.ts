import { spawn } from "node:child_process"
import { randomBytes } from "node:crypto"
import type { Stream } from "node:stream"
import { promisify } from "node:util"
import { username, zshenv } from "./constants.ts"
import { read } from "./read.ts"

const randomBytesAsync = promisify(randomBytes)

export const escapeDoubleQuotes = (str: string) => str.replace(/"/g, `\\"`)
export const escapeDollarSigns = (str: string) => str.replace(/\$/g, `\\$`)

const handleShellInputs = (stdin: Stream.Writable, inputs?: string[]) => {
  if (!inputs || inputs.length === 0) {
    return
  }
  inputs.forEach((input) => {
    stdin.write(input)
  })
  stdin.end()
}

type ShellOptions = {
  inputs?: string[]
  silent?: boolean
}

export const shell = async (command: string, options?: ShellOptions): Promise<string> => {
  command = `source ${zshenv}; ${command}`
  const cp = spawn(command, { shell: true })
  if (!options?.silent) {
    cp.stdout.pipe(process.stdout)
    cp.stderr.pipe(process.stderr)
  }
  handleShellInputs(cp.stdin, options?.inputs)

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

export const shellIsSuccessful = async (command: string, options?: ShellOptions) => {
  try {
    await shell(command, options)
    return true
  } catch {
    return false
  }
}

// uses exact string matching
export const fileContainsText = async (file: string, text: string) => {
  const escapedText = escapeDoubleQuotes(escapeDollarSigns(text))
  return shellIsSuccessful(`rg --fixed-strings "${escapedText}" ${file}`, { silent: true })
}

// uses exact string matching
export const deleteLinesContainingText = async (file: string, text: string) => {
  const escapedText = escapeDoubleQuotes(escapeDollarSigns(text))
  return shell(`perl -i -ne 'print unless index($_, "${escapedText}") >= 0' ${file}`)
}

export const addLineToZshenv = async (line: string) => {
  if (!(await fileContainsText(zshenv, line))) {
    const escapedLine = escapeDoubleQuotes(escapeDollarSigns(line))
    await shell(`echo "${escapedLine}" >> ${zshenv}`)
  }
}

export const replaceZshenvVar = async (varName: string, value: string) => {
  await deleteLinesContainingText(zshenv, varName)
  await addLineToZshenv(`export ${varName}=${value}`)
}

export const randomHexString = async (byteLength: number) => {
  const bytes = await randomBytesAsync(byteLength)
  return bytes.toString("hex")
}

const expectSettings = `
set timeout -1
match_max 100000
`

// use prepend to assign any variables before running expect command
export const runExpect = async (expectScript: string, options?: { prepend: string }) => {
  const prepend = options?.prepend ?? ""
  const command = `${prepend} expect`
  return shell(command, { inputs: [expectSettings, expectScript, "\n", "expect eof"] })
}

// read input and verify that it matches user pw
// loop until input is correct
export const readUserPassword = async (promptIn: string = "Enter user password: ") => {
  let password = ""
  let isPasswordCorrect = false
  let prompt = promptIn
  while (!isPasswordCorrect) {
    password = await read({
      prompt: prompt,
      silent: true,
      replace: "*",
    })

    isPasswordCorrect = await shellIsSuccessful(`su ${username}`, { silent: true, inputs: [password] })
    if (!isPasswordCorrect) {
      console.log("")
      prompt = "Password incorrect! Enter password again: "
    }
  }

  return password
}

// read input as password, if verify is true will make them re-enter password and verify they are equal
// if verify is true, will loop until input is correct
export const readNewPassword = async (promptIn: string = "Enter new password: ", verify = true) => {
  let password = ""
  let isPasswordCorrect = false
  let prompt = promptIn
  while (!isPasswordCorrect) {
    password = await read({
      prompt: prompt,
      silent: true,
      replace: "*",
    })

    if (verify === false) {
      return password
    }

    const password2 = await read({
      prompt: "\nRe-enter password: ",
      silent: true,
      replace: "*",
    })

    isPasswordCorrect = password === password2
    if (!isPasswordCorrect) {
      console.log("")
      prompt = `Passwords do not match. Please Try again.\n${promptIn}`
    }
  }

  return password
}

import fs from "node:fs/promises"

const keys = {
  ctrlC: "\u0003".charCodeAt(0),
  backspace: "\u0008".charCodeAt(0),
  delete: "\u007f".charCodeAt(0),
  carriageReturn: "\r".charCodeAt(0),
  lineFeed: "\n".charCodeAt(0),
} as const

export type ReadParams = {
  prompt?: string
  silent?: boolean
  replace?: string
}

export const read = async ({ prompt = "Enter input: ", silent = false, replace = "" }: ReadParams) => {
  if (replace.length > 1) {
    throw new Error("Replace must be empty string or a single character.")
  }

  const fd = await fs.open("/dev/tty", "r+")

  await fd.write(prompt)

  const currentRawMode = process.stdin.isRaw
  if (silent) {
    process.stdin.setRawMode(true)
  }

  let line = ""
  let lineComplete = false

  const charBuffer = Buffer.alloc(1)

  while (!lineComplete) {
    const data = await fd.read({ buffer: charBuffer, length: 1 })
    const charCode = data.buffer[0]
    const char = String.fromCharCode(charCode)

    switch (charCode) {
      case keys.ctrlC: // Ctrl-c
        line = ""
        lineComplete = true
        break

      case keys.backspace: // Backspace
      case keys.delete:
        if (line.length > 0) {
          line = line.slice(0, -1)
          await fd.write("\r") // move to start of line
          await fd.write(" ".repeat(prompt.length + line.length + 1)) // clear line
          await fd.write("\r") // move back to start again
          const outputText = silent ? replace.repeat(line.length) : line
          await fd.write(prompt + outputText) // output passwordLength number of *'s
        }
        break

      case keys.carriageReturn: // Enter
      case keys.lineFeed:
        lineComplete = true
        break

      default:
        await fd.write(silent ? replace : char)
        line += char
    }
  }

  if (silent) {
    process.stdin.setRawMode(currentRawMode)
  }

  return line
}

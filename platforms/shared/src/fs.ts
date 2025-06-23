import { cp, lstat, mkdir, readlink, rm, symlink, writeFile } from "node:fs/promises"
import { join } from "node:path"

// treat this like an enum (cant use enum in strip types mode)
export type PathState = (typeof PathState)[keyof typeof PathState]
export const PathState = {
  exists: "exists",
  no_exists: "no_exists",
  wrong_type: "wrong_type",
} as const

// allow keys of any function that takes no arguments and returns a boolean
type ExtractFileTypeCheckFunctions<T> = {
  [K in keyof T]: T[K] extends () => boolean ? K : never
}[keyof T]

type LStatResult = Awaited<ReturnType<typeof lstat>>
type FileTypeCheck = ExtractFileTypeCheckFunctions<LStatResult>

export const check = async (fileTypeCheck: FileTypeCheck, path: string) => {
  let stat
  try {
    stat = await lstat(path)
  } catch {
    return PathState.no_exists
  }
  if (stat[fileTypeCheck]()) {
    return PathState.exists
  } else {
    return PathState.wrong_type
  }
}

// a simpler version of the check function for when you just want a true or false value
export const checkPathExist = async (path: string) => {
  try {
    await lstat(path)
  } catch {
    return false
  }
  return true
}

export const rmrf = (path: string) => rm(path, { recursive: true, force: true })

type CheckFunc = (path: string) => Promise<PathState>

type CreateFunc = (path: string) => Promise<void>

export const ensure = async (checkFunc: CheckFunc, createFunc: CreateFunc, path: string) => {
  switch (await checkFunc(path)) {
    case PathState.exists:
      return
    case PathState.wrong_type:
      // delete the wrong type so we can create the dir
      await rmrf(path)
      break
    case PathState.no_exists:
      // make sure the parent exists and is a directory
      await ensureDir(join(path, ".."))
      break
  }
  await createFunc(path)
}

export const checkDir = (path: string) => check("isDirectory", path)

export const ensureDir = (path: string) => ensure(checkDir, mkdir, path)

export const checkFile = (path: string) => check("isFile", path)

// will reject promise if path doesn't exist
export const createFile = async (path: string) => {
  await writeFile(path, "")
}

export const ensureFile = (path: string) => ensure(checkFile, createFile, path)

// if the symlink (dst) exists but points to the wrong src, return wrong_type
export const checkSymlink = async (src: string, dst: string) => {
  switch (await check("isSymbolicLink", dst)) {
    case PathState.exists: {
      const currentSrc = await readlink(dst)
      if (currentSrc === src) {
        return PathState.exists
      }
      return PathState.wrong_type
    }
    case PathState.no_exists:
      return PathState.no_exists
    case PathState.wrong_type:
      return PathState.wrong_type
  }
}

export type FileLink = {
  src: string
  dst: string
}

export const ensureSymlink = ({ src, dst }: FileLink) =>
  ensure(checkSymlink.bind(null, src), symlink.bind(null, src), dst)

export const replaceFile = async ({ src, dst }: FileLink) => cp(src, dst, { recursive: true, force: true })

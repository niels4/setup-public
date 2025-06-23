import fs from "node:fs/promises"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { beforeAll, describe, expect, it } from "vitest"
import {
  checkDir,
  checkFile,
  checkPathExists,
  checkSymlink,
  copy_rf,
  createFile,
  ensureDir,
  ensureFile,
  ensureSymlink,
  PathState,
} from "./fs.ts"

const fixturesDir = join(tmpdir(), "setup-fs-test")

describe("shared fs", () => {
  beforeAll(async () => {
    await fs.rm(fixturesDir, { recursive: true, force: true })
    await fs.mkdir(fixturesDir, { recursive: true })
  })

  describe("checkPathExist", () => {
    describe("when path exists", () => {
      it("should return true", async () => {
        expect(await checkPathExists(fixturesDir)).toBe(true)
      })
    })

    describe("when path doesn't exist", () => {
      it("should return false", async () => {
        const badPath = join(fixturesDir, "check-path-doesnt-exist")
        expect(await checkPathExists(badPath)).toBe(false)
      })
    })
  })

  describe("checkFile", () => {
    describe("when file exists", () => {
      const existingFile = join(fixturesDir, "check-file-existing")

      beforeAll(async () => {
        await fs.writeFile(existingFile, "")
      })

      it("should return PathState.exists", async () => {
        const result = await checkFile(existingFile)
        expect(result).toBe(PathState.exists)
      })
    })

    describe("when file doesn't exist", () => {
      it("should return PathState.no_exists", async () => {
        const result = await checkFile(join(fixturesDir, "check-file-doesnt-exist"))
        expect(result).toBe(PathState.no_exists)
      })
    })

    describe("when file exist but isn't a file", () => {
      const dirPath = join(fixturesDir, "check-file-wrong-type")

      beforeAll(async () => {
        await fs.mkdir(dirPath)
      })

      it("should return PathState.wrong_type", async () => {
        const result = await checkFile(dirPath)
        expect(result).toBe(PathState.wrong_type)
      })
    })
  })

  describe("createFile", () => {
    describe("when parent already exists", () => {
      const newFile = join(fixturesDir, "create-file-parent-exists")

      it("should be able to create a file", async () => {
        await createFile(newFile)
        // we've tested checkFile so we can now use it in our tests
        const fileState = await checkFile(newFile)
        expect(fileState).toBe(PathState.exists)
      })
    })
  })

  describe("ensureFile", () => {
    describe("when file already exists", () => {
      const existingFile = join(fixturesDir, "ensure-file-existing")

      beforeAll(() => {
        createFile(existingFile)
      })

      it("should do nothing", async () => {
        await ensureFile(existingFile)
        // we've tested checkFile so we can now use it in our tests
        const fileState = await checkFile(existingFile)
        expect(fileState).toBe(PathState.exists)
      })
    })

    describe("when parent already exists", () => {
      const newFile = join(fixturesDir, "ensure-file-parent-exists")

      it("should create the file", async () => {
        await ensureFile(newFile)
        const fileState = await checkFile(newFile)
        expect(fileState).toBe(PathState.exists)
      })
    })

    describe("when parent doesn't exist", () => {
      const newFile = join(fixturesDir, "esure-file-parent-not-exist", "parent-1", "parent-2", "target-file")

      it("should recursively create parent dirs before creating file", async () => {
        await ensureFile(newFile)
        const fileState = await checkFile(newFile)
        expect(fileState).toBe(PathState.exists)
      })
    })

    describe("when path exists but isn't a file", () => {
      const wrongTypePath = join(fixturesDir, "ensure-file-wrong-type")
      beforeAll(async () => {
        await ensureDir(wrongTypePath)
      })

      it("should delete the non-file and create a file", async () => {
        await ensureFile(wrongTypePath)
        const fileState = await checkFile(wrongTypePath)
        expect(fileState).toBe(PathState.exists)
      })
    })
  })

  describe("checkDir", () => {
    describe("when dir exists", () => {
      it("should return PathState.exists", async () => {
        const result = await checkDir(fixturesDir)
        expect(result).toBe(PathState.exists)
      })
    })

    describe("when dir doesn't exist", () => {
      it("should return PathState.no_exists", async () => {
        const result = await checkDir(join(fixturesDir, "check-dir-doesnt-exist"))
        expect(result).toBe(PathState.no_exists)
      })
    })

    describe("when path exist but isn't a directory", () => {
      const filePath = join(fixturesDir, "check-dir-wrong-type")

      beforeAll(async () => {
        // we've tested createFile so we can now use it in our tests
        await createFile(filePath)
      })

      it("should return PathState.wrong_type", async () => {
        const result = await checkDir(filePath)
        expect(result).toBe(PathState.wrong_type)
      })
    })
  })

  describe("ensureDir", () => {
    describe("when dir already exists", () => {
      it("should do nothing", async () => {
        await ensureDir(fixturesDir)
        // we've tested checkDir so we can now use it in our tests
        const dirState = await checkDir(fixturesDir)
        expect(dirState).toBe(PathState.exists)
      })
    })

    describe("when parent already exists", () => {
      const newDir = join(fixturesDir, "ensure-dir-parent-exists")

      it("should create the directory", async () => {
        await ensureDir(newDir)
        const dirState = await checkDir(newDir)
        expect(dirState).toBe(PathState.exists)
      })
    })

    describe("when parent doesn't exists", () => {
      const newDir = join(fixturesDir, "esure-dir-parent-not-exist", "parent-1", "parent-2", "target-dir")

      it("should recursively create parent dirs before creating dir", async () => {
        await ensureDir(newDir)
        const dirState = await checkDir(newDir)
        expect(dirState).toBe(PathState.exists)
      })
    })

    describe("when path exists but isn't a directory", () => {
      const wrongTypePath = join(fixturesDir, "ensure-dir-wrong-type")
      beforeAll(async () => {
        await createFile(wrongTypePath)
      })

      it("should delete the file and create a directory", async () => {
        await ensureDir(wrongTypePath)
        const dirState = await checkDir(wrongTypePath)
        expect(dirState).toBe(PathState.exists)
      })
    })

    describe("when a parent path exists but isn't a directory", () => {
      const wrongTypePath = join(fixturesDir, "ensure-dir-parent-wrong-type")
      const newDir = join(wrongTypePath, "parent2", "target-dir")

      beforeAll(async () => {
        await createFile(wrongTypePath)
      })

      it("should delete the file and recursively create the directory", async () => {
        await ensureDir(newDir)
        const dirState = await checkDir(newDir)
        expect(dirState).toBe(PathState.exists)
      })
    })
  })

  describe("checkSymlink", () => {
    describe("when the link exists", () => {
      describe("and points to the correct src", () => {
        const src = join(fixturesDir, "check-symlink-correct-src")
        const dst = join(fixturesDir, "check-symlink-correct-dst")

        beforeAll(async () => {
          await createFile(src)
          await fs.symlink(src, dst)
        })

        it("should return PathState.exists", async () => {
          const linkState = await checkSymlink(src, dst)
          expect(linkState).toBe(PathState.exists)
        })
      })

      describe("and points to the incorrect src", () => {
        const src = join(fixturesDir, "check-symlink-wrong-src")
        const wrongSrc = join(fixturesDir, "check-symlink-wrong-src-link")
        const dst = join(fixturesDir, "check-symlink-wrong-dst")

        beforeAll(async () => {
          await createFile(src)
          await createFile(wrongSrc)
          await fs.symlink(wrongSrc, dst)
        })

        it("should return PathState.wrong_type", async () => {
          const linkState = await checkSymlink(src, dst)
          expect(linkState).toBe(PathState.wrong_type)
        })
      })
    })

    describe("when the path exists but is not a link", () => {
      const src = join(fixturesDir, "check-symlink-wrong-type-src")
      const dst = join(fixturesDir, "check-symlink-wrong-type-dst")

      beforeAll(async () => {
        await createFile(src)
        await createFile(dst)
      })

      it("should return PathState.wrong_type", async () => {
        const linkState = await checkSymlink(src, dst)
        expect(linkState).toBe(PathState.wrong_type)
      })
    })

    describe("when the path doesn't exist", () => {
      const src = join(fixturesDir, "check-symlink-no-exist-src")
      const dst = join(fixturesDir, "check-symlink-no-exist-dst")

      beforeAll(async () => {
        await createFile(src)
      })

      it("should return PathState.no_exists", async () => {
        const linkState = await checkSymlink(src, dst)
        expect(linkState).toBe(PathState.no_exists)
      })
    })
  })

  describe("ensureSymlink", () => {
    describe("when the link exists", () => {
      describe("and points to the correct src", () => {
        const src = join(fixturesDir, "ensure-symlink-correct-src")
        const dst = join(fixturesDir, "ensure-symlink-correct-dst")

        beforeAll(async () => {
          await createFile(src)
          await fs.symlink(src, dst)
        })

        it("should do nothing", async () => {
          await ensureSymlink({ src, dst })
          const linkState = await checkSymlink(src, dst)
          expect(linkState).toBe(PathState.exists)
        })
      })

      describe("and points to the incorrect src", () => {
        const src = join(fixturesDir, "ensure-symlink-wrong-src")
        const wrongSrc = join(fixturesDir, "ensure-symlink-wrong-src-link")
        const dst = join(fixturesDir, "ensure-symlink-wrong-dst")

        beforeAll(async () => {
          await createFile(src)
          await createFile(wrongSrc)
          await fs.symlink(wrongSrc, dst)
        })

        it("should recreate the link with the correct src", async () => {
          await ensureSymlink({ src, dst })
          const linkState = await checkSymlink(src, dst)
          expect(linkState).toBe(PathState.exists)
        })
      })
    })

    describe("when the path exists but is not a link", () => {
      const src = join(fixturesDir, "ensure-symlink-wrong-type-src")
      const dst = join(fixturesDir, "ensure-symlink-wrong-type-dst")

      beforeAll(async () => {
        await createFile(src)
        await createFile(dst)
      })

      it("should delete the file and create the symlink", async () => {
        await ensureSymlink({ src, dst })
        const linkState = await checkSymlink(src, dst)
        expect(linkState).toBe(PathState.exists)
      })
    })

    describe("when the path doesn't exist", () => {
      const src = join(fixturesDir, "ensure-symlink-no-exist-src")
      const dst = join(fixturesDir, "ensure-symlink-no-exist-dst", "parent1", "parent2")

      beforeAll(async () => {
        await createFile(src)
      })

      it("should create the symlink and any necessary parent directories", async () => {
        await ensureSymlink({ src, dst })
        const linkState = await checkSymlink(src, dst)
        expect(linkState).toBe(PathState.exists)
      })
    })
  })

  describe("replaceFile", () => {
    describe("when there already exists a file at the path", () => {
      const src = join(fixturesDir, "replace-file-src")
      const dst = join(fixturesDir, "replace-file-dst")

      beforeAll(async () => {
        await fs.writeFile(src, "Source File Content")
        await fs.writeFile(dst, "Existing File")
      })

      it("should replace the existing file with the src file", async () => {
        await copy_rf({ src, dst })
        const fileContents = (await fs.readFile(dst)).toString()
        expect(fileContents).toBe("Source File Content")
      })
    })
  })
})

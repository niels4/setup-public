#!/usr/bin/env node

import { readUserPassword } from "#shared/src/util.ts"

const prompt = process.argv[2]

const password = await readUserPassword(prompt)

process.stdout.write(password)

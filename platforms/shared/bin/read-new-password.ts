#!/usr/bin/env node

import { readNewPassword } from "#shared/src/util.ts"

const prompt = process.argv[2]

const password = await readNewPassword(prompt)

process.stdout.write(password)

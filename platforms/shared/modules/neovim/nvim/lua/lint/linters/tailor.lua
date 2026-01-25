-- local lint = require 'lint'

---  Example tailor json output

--   "files": [
--     {
--       "path": "/path/to/filename.swift",
--       "violations": [
--         {
--           "severity": "warning",
--           "rule": "upper-camel-case",
--           "location": {
--             "line": 2,
--             "column": 8
--           },
--           "message": "Struct names should be UpperCamelCase"
--         },
--         {
--           "severity": "warning",
--           "rule": "function-whitespace",
--           "location": {
--             "line": 3,
--             "column": 5
--           },
--           "message": "Function should have at least one blank line before it"
--         },
--         {
--           "severity": "warning",
--           "rule": "function-whitespace",
--           "location": {
--             "line": 12,
--             "column": 6
--           },
--           "message": "Function should have at least one blank line after it"
--         }
--       ],
--       "parsed": true
--     }
--   ],
--   "summary": {
--     "violations": 3,
--     "warnings": 3,
--     "analyzed": 1,
--     "errors": 0,
--     "skipped": 0
--   }
-- }

---@class TailorLocation
---@field line integer
---@field column integer

---@class TailorViolation
---@field message string
---@field severity string
---@field rule string
---@field location TailorLocation

---@class TailorFile
---@field violations TailorViolation[]

---@class TailorOutput
---@field files TailorFile[]

---@class LintDiagnostic
---@field source string
---@field message string
---@field code string
---@field lnum integer
---@field col integer
---@field severity vim.diagnostic.Severity

local SOURCE = 'tailor'

local severity_mapping = {
  warning = vim.diagnostic.severity.WARN,
  error = vim.diagnostic.severity.ERROR,
}

return {
  cmd = 'tailor',
  args = { '--format=json' },
  env = { JAVA_OPTS = '--enable-native-access=ALL-UNNAMED' },
  stdin = false,
  append_fname = true,
  stream = 'stdout',
  ignore_exitcode = false,

  ---@param output_str string
  ---@return LintDiagnostic[]
  parser = function(output_str)
    ---@type LintDiagnostic[]
    local diagnostics = {}

    ---@type TailorOutput
    local output = vim.json.decode(output_str)

    if #output.files ~= 1 then
      return diagnostics
    end

    local violations = output.files[1].violations

    for _, violation in ipairs(violations) do
      table.insert(diagnostics, {
        source = SOURCE,
        lnum = violation.location.line - 1,
        col = violation.location.column,
        message = violation.message,
        code = violation.rule,
        severity = severity_mapping[violation.severity],
      })
    end

    return diagnostics
  end,
}

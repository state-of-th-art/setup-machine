-- Diagnostic utilities
local M = {}

-- Format specifically for AI consumption
function M.copy_errors_for_ai()
  local errors = {}
  local buffers = vim.api.nvim_list_bufs()
  local project_root = vim.fn.getcwd()

  -- Add project context
  table.insert(errors, "PROJECT: " .. vim.fn.fnamemodify(project_root, ":t"))
  table.insert(errors, "LANGUAGE: " .. (vim.bo.filetype or "unknown"))
  table.insert(errors, "LSP CLIENTS: " .. table.concat(
    vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients()),
    ", "
  ))
  table.insert(errors, "\n=== ERROR DIAGNOSTICS ===\n")

  local error_count = 0
  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
      local filepath = vim.api.nvim_buf_get_name(bufnr)

      if #diagnostics > 0 and filepath ~= "" then
        local relative_path = vim.fn.fnamemodify(filepath, ":.")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        for _, diagnostic in ipairs(diagnostics) do
          error_count = error_count + 1
          local line_num = diagnostic.lnum + 1
          local error_line = lines[diagnostic.lnum + 1] or ""

          table.insert(errors, string.format(
            "ERROR #%d:\nFile: %s\nLine: %d\nMessage: %s\nSource: %s\nCode: %s\n",
            error_count,
            relative_path,
            line_num,
            diagnostic.message,
            diagnostic.source or "LSP",
            error_line:match("^%s*(.-)%s*$") or error_line -- trim whitespace
          ))
        end
      end
    end
  end

  if error_count > 0 then
    table.insert(errors, "=== END OF ERRORS ===")
    table.insert(errors, "\nPlease help me understand and fix these " .. error_count .. " errors.")

    local error_text = table.concat(errors, "\n")
    vim.fn.setreg('+', error_text)
    print("Copied " .. error_count .. " errors in AI-friendly format")
  else
    print("No errors found!")
  end
end

-- Copy errors from current buffer only
function M.copy_current_buffer_errors()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local relative_path = vim.fn.fnamemodify(filepath, ":.")

  if #diagnostics == 0 then
    print("No errors in current buffer!")
    return
  end

  local errors = { "=== ERRORS IN " .. relative_path .. " ===" }
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, diagnostic in ipairs(diagnostics) do
    local line_num = diagnostic.lnum + 1
    local error_line = lines[diagnostic.lnum + 1] or ""

    table.insert(errors, string.format(
      "\nLine %d: %s\nCode: %s\nSource: %s",
      line_num,
      diagnostic.message,
      error_line:gsub("^%s+", ""), -- trim leading whitespace
      diagnostic.source or "LSP"
    ))
  end

  local error_text = table.concat(errors, "\n")
  vim.fn.setreg('+', error_text)
  print("Copied " .. #diagnostics .. " errors from current buffer")
end

-- Interactive diagnostic copier
function M.copy_diagnostics_interactive()
  local options = {
    { key = "e", desc = "Errors only",              severities = { vim.diagnostic.severity.ERROR } },
    { key = "w", desc = "Errors + Warnings",        severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
    { key = "i", desc = "Errors + Warnings + Info", severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO } },
    { key = "a", desc = "All diagnostics",          severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO, vim.diagnostic.severity.HINT } },
  }

  print("Choose diagnostics to copy:")
  for _, option in ipairs(options) do
    print("  " .. option.key .. ": " .. option.desc)
  end

  local choice = vim.fn.input("Enter choice e(errors)/ w(errors+warnings)/ i(+info)/ a(all): "):lower()

  local selected_option = nil
  for _, option in ipairs(options) do
    if choice == option.key then
      selected_option = option
      break
    end
  end

  if not selected_option then
    print("Invalid choice!")
    return
  end

  -- Use the same logic as before but with selected severities
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr, { severity = selected_option.severities })
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local relative_path = vim.fn.fnamemodify(filepath, ":.")

  if #diagnostics == 0 then
    print("No " .. selected_option.desc:lower() .. " in current buffer!")
    return
  end

  -- Sort diagnostics
  table.sort(diagnostics, function(a, b)
    if a.severity == b.severity then
      return a.lnum < b.lnum
    end
    return a.severity < b.severity
  end)

  local output = { "=== " .. selected_option.desc:upper() .. " IN " .. relative_path .. " ===" }
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

  for _, diagnostic in ipairs(diagnostics) do
    local line_num = diagnostic.lnum + 1
    local error_line = lines[diagnostic.lnum + 1] or ""
    local severity_name = vim.diagnostic.severity[diagnostic.severity]
    local severity_icons = { ERROR = "❌", WARN = "⚠️ ", INFO = "ℹ️ ", HINT = "💡" }

    counts[severity_name] = counts[severity_name] + 1

    table.insert(output, string.format(
      "\n%s Line %d [%s]: %s\nCode: %s\nSource: %s",
      severity_icons[severity_name] or "•",
      line_num,
      severity_name,
      diagnostic.message,
      error_line:gsub("^%s+", ""),
      diagnostic.source or "LSP"
    ))
  end

  local result_text = table.concat(output, "\n")
  vim.fn.setreg('+', result_text)

  local status_parts = {}
  for severity, count in pairs(counts) do
    if count > 0 then
      table.insert(status_parts, count .. " " .. severity:lower() .. (count == 1 and "" or "s"))
    end
  end

  print("✅ Copied " .. table.concat(status_parts, ", ") .. " from current buffer")
end

return M 
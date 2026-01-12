local M = {}

-- To customize notes path, set environment variable:
-- Linux/Mac: export NOTES_PATH="/path/to/your/notes"
-- Windows (PowerShell): $env:NOTES_PATH="C:\path\to\your\notes"
-- Windows (CMD): set NOTES_PATH=C:\path\to\your\notes

-- PARA plugin config
M.config = {
  notes_path = vim.fn.getenv("NOTES_PATH") ~= vim.NIL 
    and vim.fn.getenv("NOTES_PATH") 
    or vim.fn.expand("~/personal/second_brain"),
  inbox_folder = "0 Inbox", -- Inbox folder name
  categories = {"1 Projects", "2 Areas", "3 Resources", "4 Archive"},
  icons = {
    ["1 Projects"] = "🚀",
    ["2 Areas"] = "🎯", 
    ["3 Resources"] = "📚",
    ["4 Archive"] = "📦"
  }
}

-- Scan folders inside a category
function M.scan_para_folders(category)
  local base_path = M.config.notes_path .. "/" .. category
  local folders = {}
  
  -- Ensure category folder exists
  if vim.fn.isdirectory(base_path) == 1 then
    local items = vim.fn.readdir(base_path)
    for _, item in ipairs(items) do
      local full_path = base_path .. "/" .. item
      -- Add directories only, skip files
      if vim.fn.isdirectory(full_path) == 1 then
        table.insert(folders, item)
      end
    end
  else
    vim.notify("Directory " .. base_path .. " does not exist", vim.log.levels.WARN)
  end
  
  return folders
end

-- Telescope functions
function M.telescope_para_categories(current_file)
  -- Ensure Telescope is available
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify("Telescope not available, using fallback UI", vim.log.levels.WARN)
    -- Fallback to simple UI
    vim.ui.select(M.config.categories, {
      prompt = "Move file to PARA category:",
      format_item = function(item)
        return M.config.icons[item] .. " " .. item
      end
    }, function(category)
      if category then
        local folders = M.scan_para_folders(category)
        M.select_folder_simple(current_file, category, folders)
      end
    end)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  -- Build category list with icons
  local category_items = {}
  for _, category in ipairs(M.config.categories) do
    table.insert(category_items, {
      display = M.config.icons[category] .. " " .. category,
      value = category
    })
  end
  
  pickers.new({}, {
    prompt_title = "📁 PARA Categories",
    initial_mode = "normal",
    finder = finders.new_table {
      results = category_items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.value
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Jump to folder picker for the selected category
          M.telescope_folder_picker(current_file, selection.value)
        end
      end)
      return true
    end,
  }):find()
end

-- Main file organization function
function M.organize_file()
  local current_file = vim.fn.expand('%:p')
  
  -- Ensure file exists
  if current_file == "" or vim.fn.filereadable(current_file) == 0 then
    vim.notify("No file to organize", vim.log.levels.WARN)
    return
  end
  
  -- Start Telescope picker for categories
  M.telescope_para_categories(current_file)
end

-- Telescope picker for folders
function M.telescope_folder_picker(current_file, category)
  -- Ensure Telescope is available
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify("Telescope not available, using fallback UI", vim.log.levels.WARN)
    local folders = M.scan_para_folders(category)
    M.select_folder_simple(current_file, category, folders)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')
  
  local folders = M.scan_para_folders(category)
  
  -- Build folder list with extra info
  local folder_items = {}
  
  -- Add "create new folder" option at the top
  table.insert(folder_items, {
    display = "➕ Create new folder",
    value = "__create_new_folder__",
    path = nil,
    is_create_option = true
  })
  
  for _, folder in ipairs(folders) do
    local full_path = M.config.notes_path .. "/" .. category .. "/" .. folder
    local files_count = #vim.fn.readdir(full_path)
    
    table.insert(folder_items, {
      display = "📁 " .. folder .. " (" .. files_count .. " files)",
      value = folder,
      path = full_path,
      is_create_option = false
    })
  end
  
  pickers.new({}, {
    prompt_title = M.config.icons[category] .. " " .. category .. " Folders",
    initial_mode = "normal",
    finder = finders.new_table {
      results = folder_items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.value,
          path = entry.path
        }
      end
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_termopen_previewer {
      get_command = function(entry)
        -- Show files in folder
        return { "ls", "-la", entry.path }
      end
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Handle "create new folder" option
          if selection.value == "__create_new_folder__" then
            M.create_folder_in_category(category, function()
              -- Return to folder picker after creation
              M.telescope_folder_picker(current_file, category)
            end)
          else
            M.move_file_to_folder(current_file, category, selection.value)
          end
        end
      end)
      
      -- Quick create folder via Ctrl+N
      map('i', '<C-n>', function()
        actions.close(prompt_bufnr)
        M.create_folder_in_category(category, function()
          -- Return to folder picker after creation
          M.telescope_folder_picker(current_file, category)
        end)
      end)
      
      map('n', '<C-n>', function()
        actions.close(prompt_bufnr)
        M.create_folder_in_category(category, function()
          -- Return to folder picker after creation
          M.telescope_folder_picker(current_file, category)
        end)
      end)
      
      return true
    end,
  }):find()
end

-- Telescope picker for multi-file moves - category selection
function M.telescope_para_categories_multiple(file_paths)
  -- Ensure Telescope is available
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify("Telescope not available, using fallback UI", vim.log.levels.WARN)
    -- Fallback to simple UI
    vim.ui.select(M.config.categories, {
      prompt = "Move " .. #file_paths .. " files to PARA category:",
      format_item = function(item)
        return M.config.icons[item] .. " " .. item
      end
    }, function(category)
      if category then
        local folders = M.scan_para_folders(category)
        M.select_folder_simple_multiple(file_paths, category, folders)
      end
    end)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  -- Build category list with icons
  local category_items = {}
  for _, category in ipairs(M.config.categories) do
    table.insert(category_items, {
      display = M.config.icons[category] .. " " .. category,
      value = category
    })
  end
  
  pickers.new({}, {
    prompt_title = "📁 PARA Categories (Moving " .. #file_paths .. " files)",
    initial_mode = "normal",
    finder = finders.new_table {
      results = category_items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.value
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Jump to folder picker for the selected category
          M.telescope_folder_picker_multiple(file_paths, selection.value)
        end
      end)
      return true
    end,
  }):find()
end

-- Telescope picker for multi-file moves - folder selection
function M.telescope_folder_picker_multiple(file_paths, category)
  -- Ensure Telescope is available
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify("Telescope not available, using fallback UI", vim.log.levels.WARN)
    local folders = M.scan_para_folders(category)
    M.select_folder_simple_multiple(file_paths, category, folders)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')
  
  local folders = M.scan_para_folders(category)
  
  -- Build folder list with extra info
  local folder_items = {}
  
  -- Add "create new folder" option at the top
  table.insert(folder_items, {
    display = "➕ Create new folder",
    value = "__create_new_folder__",
    path = nil,
    is_create_option = true
  })
  
  for _, folder in ipairs(folders) do
    local full_path = M.config.notes_path .. "/" .. category .. "/" .. folder
    local files_count = #vim.fn.readdir(full_path)
    
    table.insert(folder_items, {
      display = "📁 " .. folder .. " (" .. files_count .. " files)",
      value = folder,
      path = full_path,
      is_create_option = false
    })
  end
  
  pickers.new({}, {
    prompt_title = M.config.icons[category] .. " " .. category .. " Folders (Moving " .. #file_paths .. " files)",
    initial_mode = "normal",
    finder = finders.new_table {
      results = folder_items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.value,
          path = entry.path
        }
      end
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_termopen_previewer {
      get_command = function(entry)
        -- Show files in folder
        return { "ls", "-la", entry.path }
      end
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Handle "create new folder" option
          if selection.value == "__create_new_folder__" then
            M.create_folder_in_category(category, function()
              -- Return to folder picker after creation
              M.telescope_folder_picker_multiple(file_paths, category)
            end)
          else
            M.move_multiple_files_to_folder(file_paths, category, selection.value)
          end
        end
      end)
      
      -- Quick create folder via Ctrl+N
      map('i', '<C-n>', function()
        actions.close(prompt_bufnr)
        M.create_folder_in_category(category, function()
          -- Return to folder picker after creation
          M.telescope_folder_picker_multiple(file_paths, category)
        end)
      end)
      
      map('n', '<C-n>', function()
        actions.close(prompt_bufnr)
        M.create_folder_in_category(category, function()
          -- Return to folder picker after creation
          M.telescope_folder_picker_multiple(file_paths, category)
        end)
      end)
      
      return true
    end,
  }):find()
end

-- Simple UI folder selection for multi-file moves
function M.select_folder_simple_multiple(file_paths, category, folders)
  -- Show folder list for selection
  vim.ui.select(folders, {
    prompt = "Select folder in " .. M.config.icons[category] .. " " .. category .. " (Moving " .. #file_paths .. " files):",
    format_item = function(item)
      return "📁 " .. item
    end
  }, function(folder)
    if folder then
      M.move_multiple_files_to_folder(file_paths, category, folder)
    end
  end)
end

-- Simple UI folder selection (fallback)
function M.select_folder_simple(file_path, category, folders)
  -- Show folder list for selection
  vim.ui.select(folders, {
    prompt = "Select folder in " .. M.config.icons[category] .. " " .. category .. ":",
    format_item = function(item)
      return "📁 " .. item
    end
  }, function(folder)
    if folder then
      M.move_file_to_folder(file_path, category, folder)
    end
  end)
end

-- Move a single file
function M.move_file_to_folder(file_path, category, folder)
  local filename = vim.fn.fnamemodify(file_path, ':t')
  local destination = M.config.notes_path .. "/" .. category .. "/" .. folder .. "/" .. filename
  
  -- Ensure file doesn't already exist in destination
  if vim.fn.filereadable(destination) == 1 then
    vim.notify("File already exists in destination: " .. destination, vim.log.levels.ERROR)
    return
  end
  
  -- Track current buffer before moving
  local current_bufnr = vim.fn.bufnr('%')
  local current_buffer_valid = vim.api.nvim_buf_is_valid(current_bufnr)
  
  -- Use system move command
  local cmd = "mv '" .. file_path .. "' '" .. destination .. "'"
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error == 0 then
    vim.notify("📁 File moved to: " .. destination, vim.log.levels.INFO)
    
    -- Open file at the new location
    vim.cmd("edit " .. destination)
    
    -- Close old buffer for the moved file
    if current_buffer_valid and current_bufnr ~= vim.fn.bufnr('%') then
      -- Ensure old buffer still exists and matches the old path
      if vim.api.nvim_buf_is_valid(current_bufnr) then
        local old_buffer_name = vim.api.nvim_buf_get_name(current_bufnr)
        if old_buffer_name == file_path then
          -- Close the old buffer
          vim.api.nvim_buf_delete(current_bufnr, { force = true })
          vim.notify("🗑️  Closed old buffer", vim.log.levels.INFO)
        end
      end
    end
    
    -- Open Telescope file browser in the inbox for the next file
    M.open_inbox_browser()
  else
    vim.notify("Failed to move file: " .. result, vim.log.levels.ERROR)
  end
end

-- Move multiple files
function M.move_multiple_files_to_folder(file_paths, category, folder)
  local success_count = 0
  local error_count = 0
  local errors = {}
  
  -- Ensure file list is not empty
  if not file_paths or #file_paths == 0 then
    vim.notify("No files to move", vim.log.levels.WARN)
    return false
  end
  
  vim.notify("📁 Moving " .. #file_paths .. " files to " .. category .. "/" .. folder, vim.log.levels.INFO)
  
  for _, file_path in ipairs(file_paths) do
    local filename = vim.fn.fnamemodify(file_path, ':t')
    local destination = M.config.notes_path .. "/" .. category .. "/" .. folder .. "/" .. filename
    
    -- Ensure file exists
    if vim.fn.filereadable(file_path) == 0 then
      table.insert(errors, "File not found: " .. file_path)
      error_count = error_count + 1
      goto continue
    end
    
    -- Ensure file doesn't already exist in destination
    if vim.fn.filereadable(destination) == 1 then
      table.insert(errors, "File already exists: " .. filename)
      error_count = error_count + 1
      goto continue
    end
    
    -- Move file
    local cmd = "mv '" .. file_path .. "' '" .. destination .. "'"
    local result = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
      success_count = success_count + 1
    else
      table.insert(errors, "Failed to move " .. filename .. ": " .. result)
      error_count = error_count + 1
    end
    
    ::continue::
  end
  
  -- Report results
  if success_count > 0 then
    vim.notify("✅ Successfully moved " .. success_count .. " files", vim.log.levels.INFO)
  end
  
  if error_count > 0 then
    vim.notify("❌ Failed to move " .. error_count .. " files", vim.log.levels.ERROR)
    for _, error in ipairs(errors) do
      vim.notify("  " .. error, vim.log.levels.ERROR)
    end
  end
  
  -- Open Telescope file browser in the inbox for the next file
  if success_count > 0 then
    M.open_inbox_browser()
  end
  
  return success_count > 0
end

-- Telescope picker for folder creation
function M.telescope_create_folder()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  -- Build category list
  local category_items = {}
  for _, category in ipairs(M.config.categories) do
    table.insert(category_items, {
      display = M.config.icons[category] .. " " .. category,
      value = category
    })
  end
  
  pickers.new({}, {
    prompt_title = "📂 Create Folder in Category",
    initial_mode = "normal",
    finder = finders.new_table {
      results = category_items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.value
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          M.create_folder_in_category(selection.value)
        end
      end)
      return true
    end,
  }):find()
end

-- Quick folder creation helper
function M.create_folder_in_category(category, callback)
  local base_path = M.config.notes_path .. "/" .. category
  
  vim.ui.input({
    prompt = "Create new folder in " .. M.config.icons[category] .. " " .. category .. ": ",
  }, function(folder_name)
    if folder_name and folder_name ~= "" then
      local new_folder_path = base_path .. "/" .. folder_name
      local cmd = "mkdir -p '" .. new_folder_path .. "'"
      local result = vim.fn.system(cmd)
      
      if vim.v.shell_error == 0 then
        vim.notify("📁 Created folder: " .. new_folder_path, vim.log.levels.INFO)
        
        -- Run callback after creation
        if callback then
          callback()
        end
      else
        vim.notify("Failed to create folder: " .. result, vim.log.levels.ERROR)
      end
    end
  end)
end

-- Quick move to a specific category
function M.quick_move_to_category(category)
  local current_file = vim.fn.expand('%:p')
  
  if current_file == "" or vim.fn.filereadable(current_file) == 0 then
    vim.notify("No file to organize", vim.log.levels.WARN)
    return
  end
  
  -- Use Telescope to pick folder
  M.telescope_folder_picker(current_file, category)
end

-- Open Telescope file browser in inbox
function M.open_inbox_browser()
  local inbox_path = M.config.notes_path .. "/" .. M.config.inbox_folder
  
  -- Ensure inbox folder exists
  if vim.fn.isdirectory(inbox_path) == 0 then
    vim.notify("📥 Inbox folder '" .. M.config.inbox_folder .. "' not found at: " .. inbox_path, vim.log.levels.WARN)
    return
  end
  
  -- Ensure Telescope is available
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
  end
  
  -- Delay to allow the new file to open
  vim.defer_fn(function()
    -- Try file_browser with error handling
    local success = pcall(function()
      -- Try file_browser command
      vim.cmd("Telescope file_browser path=" .. vim.fn.fnameescape(inbox_path))
    end)
    
    if not success then
      -- Fallback to find_files if file_browser fails
      local telescope_success, telescope_builtin = pcall(require, 'telescope.builtin')
      if telescope_success then
        telescope_builtin.find_files({
          cwd = inbox_path,
          prompt_title = "📥 Inbox Files",
          initial_mode = "normal"
        })
      else
        vim.notify("📥 Could not open inbox browser", vim.log.levels.WARN)
        return
      end
    end
    
    vim.notify("📥 Opening inbox for next file...", vim.log.levels.INFO)
  end, 300) -- Reduced delay to 300ms
end

-- Create a new markdown file in inbox
function M.create_new_md_file()
  local inbox_path = M.config.notes_path .. "/" .. M.config.inbox_folder
  
  -- Ensure inbox folder exists
  if vim.fn.isdirectory(inbox_path) == 0 then
    vim.notify("📥 Inbox folder '" .. M.config.inbox_folder .. "' not found at: " .. inbox_path, vim.log.levels.WARN)
    return
  end
  
  -- Ask for filename
  vim.ui.input({
    prompt = "📝 New markdown file name: ",
    default = "",
    completion = "file"
  }, function(filename)
    if not filename or filename == "" then
      vim.notify("❌ No filename provided", vim.log.levels.WARN)
      return
    end
    
    -- Add .md extension if missing
    if not filename:match("%.md$") then
      filename = filename .. ".md"
    end
    
    local file_path = inbox_path .. "/" .. filename
    
    -- Ensure file doesn't already exist
    if vim.fn.filereadable(file_path) == 1 then
      vim.notify("❌ File already exists: " .. filename, vim.log.levels.ERROR)
      return
    end
    
    -- Create file with a basic template
    local template = "# " .. filename:gsub("%.md$", ""):gsub("_", " "):gsub("^%l", string.upper) .. "\n\n"
    
    -- Write file
    local file = io.open(file_path, "w")
    if file then
      file:write(template)
      file:close()
      
      vim.notify("✅ Created new file: " .. filename, vim.log.levels.INFO)
      
      -- Open new file
      vim.cmd("edit " .. vim.fn.fnameescape(file_path))
      
      -- Move cursor to end for typing
      vim.cmd("normal G")
      
    else
      vim.notify("❌ Failed to create file: " .. filename, vim.log.levels.ERROR)
    end
  end)
end

-- Cleanup invalid buffers
function M.cleanup_invalid_buffers()
  local closed_count = 0
  local buffers = vim.api.nvim_list_bufs()
  
  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      local buffer_name = vim.api.nvim_buf_get_name(bufnr)
      -- Ensure file exists
      if buffer_name ~= "" and vim.fn.filereadable(buffer_name) == 0 then
        -- Close buffer for missing file
        vim.api.nvim_buf_delete(bufnr, { force = true })
        closed_count = closed_count + 1
      end
    end
  end
  
  if closed_count > 0 then
    vim.notify("🗑️  Closed " .. closed_count .. " invalid buffers", vim.log.levels.INFO)
  else
    vim.notify("✅ No invalid buffers found", vim.log.levels.INFO)
  end
end

-- Start multi-file move from Telescope file browser
function M.start_multiple_file_move(prompt_bufnr)
  -- Get current Telescope picker
  local action_state = require('telescope.actions.state')
  local picker = action_state.get_current_picker(prompt_bufnr)
  
  if not picker then
    vim.notify("No Telescope picker found. Use this function from Telescope file browser.", vim.log.levels.ERROR)
    return
  end
  
  -- Get selected files
  local selected_entries = picker:get_multi_selection()
  
  if #selected_entries == 0 then
    vim.notify("No files selected. Use <Tab> to select files in Telescope file browser.", vim.log.levels.WARN)
    return
  end
  
  -- Extract file paths
  local file_paths = {}
  for _, entry in ipairs(selected_entries) do
    if entry.path and vim.fn.filereadable(entry.path) == 1 then
      table.insert(file_paths, entry.path)
    end
  end
  
  if #file_paths == 0 then
    vim.notify("No valid files found in selection.", vim.log.levels.WARN)
    return
  end
  
  -- Close current Telescope picker
  local actions = require('telescope.actions')
  actions.close(prompt_bufnr)
  
  -- Start move flow
  vim.notify("Starting PARA organization for " .. #file_paths .. " files...", vim.log.levels.INFO)
  M.telescope_para_categories_multiple(file_paths)
end

-- Initialization (keymaps and commands)
function M.setup()
  -- Keymaps
  vim.keymap.set("n", "<leader>no", M.organize_file, { 
    desc = "PARA: Organize current file" 
  })
  
  -- Quick keymaps for each category
  vim.keymap.set("n", "<leader>np", function() M.quick_move_to_category("1 Projects") end, { 
    desc = "PARA: Move to Projects" 
  })
  vim.keymap.set("n", "<leader>nz", function() M.quick_move_to_category("2 Areas") end, { 
    desc = "PARA: Move to Areas" 
  })
  vim.keymap.set("n", "<leader>nr", function() M.quick_move_to_category("3 Resources") end, { 
    desc = "PARA: Move to Resources" 
  })
  vim.keymap.set("n", "<leader>na", function() M.quick_move_to_category("4 Archive") end, { 
    desc = "PARA: Move to Archive" 
  })
  
  -- Commands
  vim.api.nvim_create_user_command("PARAOrganize", M.organize_file, {
    desc = "Organize current file using PARA method"
  })
  
  vim.api.nvim_create_user_command("PARACreateFolder", function(opts)
    local category = opts.args or ""
    if category == "" then
      -- Use Telescope picker for category selection
      M.telescope_create_folder()
    else
      M.create_folder_in_category(category)
    end
  end, {
    desc = "Create new folder in PARA category",
    nargs = "?"
  })
  
  vim.api.nvim_create_user_command("PARACleanup", M.cleanup_invalid_buffers, {
    desc = "Cleanup invalid buffers (files that no longer exist)"
  })
  
  vim.api.nvim_create_user_command("PARAInbox", M.open_inbox_browser, {
    desc = "Open Telescope file browser in inbox folder"
  })
  
  vim.api.nvim_create_user_command("PARANewFile", M.create_new_md_file, {
    desc = "Create new markdown file in inbox folder"
  })
  
  -- Quick keymap for creating folders
  vim.keymap.set("n", "<leader>nf", M.telescope_create_folder, { 
    desc = "PARA: Create new folder" 
  })
  
  -- Quick keymap for inbox
  vim.keymap.set("n", "<leader>ni", M.open_inbox_browser, { 
    desc = "PARA: Open inbox browser" 
  })
  
  -- Quick keymap for a new inbox markdown file
  vim.keymap.set("n", "<leader>nn", M.create_new_md_file, { 
    desc = "PARA: Create new markdown file in inbox" 
  })
  
  -- Store in global for quick access/testing
  _G.para_organizer = M
  
  -- PARA organizer loaded silently
end

return M

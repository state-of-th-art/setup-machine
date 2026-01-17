return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          file_browser = {
            initial_mode = "normal",
            -- Customize file display
            display_stat = false, -- Hide file permissions and stats
            hide_parent_dir = false,
            respect_gitignore = true,
            -- Customize the prompt title
            prompt_title = "File Browser",
            -- Customize file display format
            file_display = function(entry, vim_state)
              local display = entry.value
              local hl_group = "TelescopeFileBrowserFile"
              
              if entry.fs_stat and entry.fs_stat.type == "directory" then
                hl_group = "TelescopeFileBrowserDirectory"
                display = display .. "/"
              end
              
              return display, hl_group
            end,
            -- Customize directory display
            dir_display = function(entry, vim_state)
              return entry.value .. "/", "TelescopeFileBrowserDirectory"
            end,
            -- Customize file sorting
            file_sorter = function(a, b)
              local a_stat = a.fs_stat
              local b_stat = b.fs_stat
              
              -- Directories first
              if a_stat.type == "directory" and b_stat.type ~= "directory" then
                return true
              elseif a_stat.type ~= "directory" and b_stat.type == "directory" then
                return false
              end
              
              -- Then sort by name
              return a.value < b.value
            end,
            -- Customize preview
            previewer = true, -- Enable preview
            -- Custom keybindings for PARA operations
            attach_mappings = function(prompt_bufnr, map)
              -- Load para_organizer only once
              local para_organizer = require('para-organizer')
              local action_state = require('telescope.actions.state')
              local actions = require('telescope.actions')
              
              -- PARA: Move multiple selected files
              map('n', '<leader>nm', function()
                para_organizer.start_multiple_file_move(prompt_bufnr)
              end)
              
              -- PARA: Move single file (current selection)
              map('n', '<leader>no', function()
                local selection = action_state.get_selected_entry()
                
                if selection and selection.path and vim.fn.filereadable(selection.path) == 1 then
                  actions.close(prompt_bufnr)
                  para_organizer.telescope_para_categories(selection.path)
                else
                  vim.notify("No valid file selected", vim.log.levels.WARN)
                end
              end)
              
              -- PARA: Quick move to Projects
              map('n', '<leader>np', function()
                local selection = action_state.get_selected_entry()
                
                if selection and selection.path and vim.fn.filereadable(selection.path) == 1 then
                  actions.close(prompt_bufnr)
                  para_organizer.quick_move_to_category("1 Projects")
                else
                  vim.notify("No valid file selected", vim.log.levels.WARN)
                end
              end)
              
              -- PARA: Quick move to Areas
              map('n', '<leader>nz', function()
                local selection = action_state.get_selected_entry()
                
                if selection and selection.path and vim.fn.filereadable(selection.path) == 1 then
                  actions.close(prompt_bufnr)
                  para_organizer.quick_move_to_category("2 Areas")
                else
                  vim.notify("No valid file selected", vim.log.levels.WARN)
                end
              end)
              
              -- PARA: Quick move to Resources
              map('n', '<leader>nr', function()
                local selection = action_state.get_selected_entry()
                
                if selection and selection.path and vim.fn.filereadable(selection.path) == 1 then
                  actions.close(prompt_bufnr)
                  para_organizer.quick_move_to_category("3 Resources")
                else
                  vim.notify("No valid file selected", vim.log.levels.WARN)
                end
              end)
              
              -- PARA: Quick move to Archive
              map('n', '<leader>na', function()
                local selection = action_state.get_selected_entry()
                
                if selection and selection.path and vim.fn.filereadable(selection.path) == 1 then
                  actions.close(prompt_bufnr)
                  para_organizer.quick_move_to_category("4 Archive")
                else
                  vim.notify("No valid file selected", vim.log.levels.WARN)
                end
              end)
              
              return true
            end,
          }
        },
        defaults = {
          file_ignore_patterns = { "%.png$", "%.jpg$" },
          -- Path display options
          path_display = {
            "truncate" -- This truncates paths intelligently
            -- Other options: "tail", "absolute", "smart", "shorten"
          },
          preview = {
            filesize_limit = 0.1, -- MB - don't preview files larger than 100KB
            timeout = 250,        -- ms - timeout for previewer
            treesitter = true,
          },
          -- Customize display for more compact view with wider preview
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.95,
              height = 0.9,
              preview_width = 0.6, -- Wider preview (60% of width)
              prompt_position = "top",
            },
          },
          -- Customize file display format
          file_display = function(entry, vim_state)
            local display = entry.value
            local hl_group = "TelescopeFileBrowserFile"
            
            if entry.fs_stat and entry.fs_stat.type == "directory" then
              hl_group = "TelescopeFileBrowserDirectory"
              display = display .. "/"
            end
            
            return display, hl_group
          end,
          -- Customize sorting
          sorting_strategy = "ascending",
          -- Customize prompt
          prompt_prefix = "> ",
          selection_caret = "> ",
          -- Customize results
          results_title = "",
          prompt_title = "",
        }
      }

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      local builtin = require("telescope.builtin")
      -- Find operations
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find Symbols" })
      vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Find Definitions" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find References" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find Word" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find by Grep" })
      vim.keymap.set("n", "<leader>fe", function()
        builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Find Errors" })
      vim.keymap.set("n", "<leader>fn", function()
        local notes_path = vim.fn.getenv("NOTES_PATH") ~= vim.NIL
          and vim.fn.getenv("NOTES_PATH")
          or vim.fn.expand("~/personal/second_brain")
        builtin.find_files {
          cwd = notes_path
        }
      end, { desc = "Find in Notes" })

      -- Git operations
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gC", builtin.git_bcommits, { desc = "Git Buffer Commits" })

      -- Recent files
      vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = "Recent Files" })

      vim.keymap.set('n', '<leader>fB', '<cmd>Telescope file_browser<cr>', { desc = 'File browser' })
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>',
        { desc = 'File browser (current file dir)' })
      vim.keymap.set('n', '<leader>fN', function()
        local notes_path = vim.fn.getenv("NOTES_PATH") ~= vim.NIL 
          and vim.fn.getenv("NOTES_PATH") 
          or vim.fn.expand("~/personal/second_brain")
        vim.cmd("Telescope file_browser path=" .. vim.fn.fnameescape(notes_path))
      end, { desc = 'File browser (notes)' })
      
      -- PARA operations in file browser:
      -- <leader>nm - Move multiple selected files (use <Tab> to select files first)
      -- <leader>no - Move single file (current selection)
      -- <leader>np - Quick move to Projects
      -- <leader>nz - Quick move to Areas  
      -- <leader>nr - Quick move to Resources
      -- <leader>na - Quick move to Archive
    end
  }
}

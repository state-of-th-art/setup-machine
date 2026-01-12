return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = function()
            -- UFO folding configuration
            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Setup UFO with proper providers
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                    local newVirtText = {}
                    local suffix = ' 󰁂 ' .. tostring(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText = truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, {chunkText, hlGroup})
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            -- str width returned from truncate() may less than 2nd argument, need padding
                            if curWidth + chunkWidth < targetWidth then
                                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, {suffix, 'MoreMsg'})
                    return newVirtText
                end
            })

            -- UFO keymaps
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
            
            -- Gradual fold open/close
            vim.keymap.set('n', 'zr', function()
                local ufo = require('ufo')
                local current_level = vim.o.foldlevel
                vim.o.foldlevel = math.min(current_level + 1, 99)
            end, { desc = 'Increase fold level (open more)' })
            
            vim.keymap.set('n', 'zm', function()
                local ufo = require('ufo')
                local current_level = vim.o.foldlevel
                vim.o.foldlevel = math.max(current_level - 1, 0)
            end, { desc = 'Decrease fold level (close more)' })
        end,
    },
}

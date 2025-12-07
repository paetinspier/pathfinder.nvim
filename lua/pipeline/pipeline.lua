local M = {}

-- Function to get files in current directory (non-recursive)
local function get_files()
    local dir = vim.uv.cwd()
    local files = {}
    local iter, _ = vim.fs.dir(dir)
    for name, type in iter do
        if type == 'file' then
            table.insert(files, name)
        end
    end
    table.sort(files)  -- Sort alphabetically
    return files
end

-- Function to create a floating window
local function create_floating_win(buf, width, height, row, col)
    return vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single',
    })
end

-- Function to update preview buffer
local function update_preview(preview_buf, filename)
    local full_path = vim.uv.cwd() .. '/' .. filename
    local ok, lines = pcall(vim.fn.readfile, full_path)
    if ok and #lines > 0 then
        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(preview_buf, 'filetype', vim.fn.fnamemodify(filename, ':e'))  -- Set syntax
    else
        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { 'Preview not available (binary or empty file)' })
    end
end

-- Main function to open the lister
function M.start()
    local files = get_files()
    if #files == 0 then
        vim.notify('No files in current directory', vim.log.levels.INFO)
        return
    end

    -- Create list buffer
    local list_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, files)
    vim.api.nvim_buf_set_option(list_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(list_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(list_buf, 'modifiable', false)

    -- Create preview buffer
    local preview_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(preview_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(preview_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(preview_buf, 'modifiable', false)

    -- Window dimensions (adjust as needed)
    local width = math.floor(vim.o.columns * 0.3)
    local height = math.floor(vim.o.lines * 0.6)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - (width * 2)) / 2)  -- Space for two windows side-by-side

    -- Open list window
    local list_win = create_floating_win(list_buf, width, height, row, col)

    -- Open preview window next to it
    local preview_win = create_floating_win(preview_buf, width, height, row, col + width + 2)

    -- Set initial preview to first file
    vim.api.nvim_win_set_cursor(list_win, {1, 0})
    update_preview(preview_buf, files[1])

    -- Keymaps for list buffer
    local function close_all()
        vim.api.nvim_win_close(list_win, true)
        vim.api.nvim_win_close(preview_win, true)
    end

    vim.api.nvim_buf_set_keymap(list_buf, 'n', '<Esc>', '', { noremap = true, silent = true, callback = close_all })
    vim.api.nvim_buf_set_keymap(list_buf, 'n', 'q', '', { noremap = true, silent = true, callback = close_all })
    vim.api.nvim_buf_set_keymap(list_buf, 'n', '<CR>', '', {
        noremap = true,
        silent = true,
        callback = function()
            local line = vim.api.nvim_win_get_cursor(list_win)[1]
            local file = files[line]
            close_all()
            vim.cmd('edit ' .. vim.fn.fnameescape(vim.uv.cwd() .. '/' .. file))
        end
    })

    -- Update preview on cursor move
    vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = list_buf,
        callback = function()
            local line = vim.api.nvim_win_get_cursor(list_win)[1]
            update_preview(preview_buf, files[line])
        end,
    })
end

return M

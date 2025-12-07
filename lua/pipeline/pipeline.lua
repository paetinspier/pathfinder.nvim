local M = {}

function M.start()
    local lines = {
        "Hello from a Neovim Floating Window!",
        "------------------------------------",
        "This is a custom popup created with Lua.",
        "Press 'q' or '<Esc>' to close it."
    }

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local height = 30
	local width = 100
	local row = (vim.api.nvim_win_get_height(0) - height) / 2
	local col = (vim.api.nvim_win_get_width(0) - width) / 2
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		focusable = true,
		style = "minimal",
	})

	vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
end

return M

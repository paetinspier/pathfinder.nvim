local M = {}

--- Configures the plugin buffer settings
--- @param buf integer Buffer id
--- @param win integer Window id
function ConfigureSettings(buf, win)
	local function close()
		vim.api.nvim_win_close(win, true)
	end
	vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', { noremap = true, silent = true, callback = close })
	vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', { noremap = true, silent = true, callback = close })
end

function M.startPathfinder()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * .5)
	local height = math.floor(vim.o.lines * .5)
	local row = math.floor(height / 2)
	local col = math.floor(width / 2)
	local win = vim.api.nvim_open_win(buf, true,
		{ relative = 'editor', row = row, col = col, width = width, height = height })

	ConfigureSettings(buf, win)
end

vim.api.nvim_create_user_command("Pathfinder", function()
	M.startPathfinder()
end, { desc = "Starting Pathfinder" })

return M

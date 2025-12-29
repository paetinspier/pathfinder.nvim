local M = {}

function M.startPathfinder()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * .5)
	local height = math.floor(vim.o.lines * .5)
	local row = math.floor(height / 2)
	local col = math.floor(width / 2)

	vim.api.nvim_open_win(buf, true,
		{ relative = 'editor', row = row, col = col, width = width, height = height })
	vim.api.nvim_set_current_buf(buf)
end

vim.api.nvim_buf_create_user_command(0, "Pathfinder", function()
	M.startPathfinder()
end, { desc = "Starting Pathfinder" })

return M

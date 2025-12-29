local M = {}

function M.startPathfinder()
	vim.api.nvim_open_win(0, false,
		{ relative = 'win', row = 3, col = 3, width = 12, height = 3 })
end

vim.api.nvim_buf_create_user_command(0, "Pathfinder", function()
	M.startPathfinder()
end, { desc = "Starting Pathfinder" })

return M

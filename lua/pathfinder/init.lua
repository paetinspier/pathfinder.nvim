local M = {}

function M.startPathfinder()
	print("starting pathfinder")
end

vim.api.nvim_buf_create_user_command(0, "Pathfinder", function()
	M.startPathfinder()
end, { desc = "Starting Pathfinder"})

return M

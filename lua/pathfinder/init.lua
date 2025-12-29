function startPathfinder()
	print("starting pathfinder")
end

vim.api.nvim_buf_create_user_command(0, "Pathfinder", startPathfinder())

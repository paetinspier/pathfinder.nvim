local pipeline = require("pipeline")

vim.api.nvim_create_user_command(
	"Pipeline",
	function ()
		pipeline.start()
	end,
	{
		desc = "Opens pipeline"
	}
)

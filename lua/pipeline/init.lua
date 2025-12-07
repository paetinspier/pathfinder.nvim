local pipeline = require("pipeline.pipeline")

vim.api.nvim_create_user_command(
	"Open pipeline",
	function ()
		pipeline.start()
	end,
	{
		desc = "Opens pipeline"
	}
)

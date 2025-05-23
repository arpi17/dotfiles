return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua", -- Use FzfLua to search Todo comments
	},
	opts = {},
	keys = {
		{ "<leader>ft", "<cmd>TodoFzfLua<CR>", desc = "[F]ind [T]odos" },
	},
}

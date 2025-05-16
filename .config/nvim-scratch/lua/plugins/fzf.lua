return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	config = function()
		require("fzf-lua").register_ui_select()
	end,
	keys = {
		{ "<leader><Space>", "<cmd>FzfLua files<CR>", desc = "Find Files" },
		{ "<leader>/", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
		{ "<leader>fc", "<cmd>FzfLua files cwd=~/.config/nvim-scratch<CR>", desc = "[F]ind [C]onfig files" },
		{ "<leader>fb", "<cmd>FzfLua buffers <CR>", desc = "[F]ind [B]uffers" },
	},
}

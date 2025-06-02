return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "%d+L, %d+B written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "%S+ %d+L, %d+B",
					},
					opts = { skip = true },
				},
			},
		})
		vim.keymap.set(
			"n",
			"<leader>nd",
			"<cmd>NoiceDismiss<CR>",
			{ silent = true, desc = "Dismiss Noice notifications" }
		)
	end,
}

return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.nixpkgs_fmt,
			},
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end,
}

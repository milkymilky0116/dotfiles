return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "nil_ls", "gopls", "rust_analyzer", "ts_ls", "denols" },
				opts = {
					auto_install = true,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.nil_ls.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.denols.setup({ capabilities = capabilities })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

			vim.keymap.set("n", "<leader>cd", function()
				vim.diagnostic.open_float(nil, { border = "rounded" })
			end, {})
			vim.keymap.set("n", "cr", function()
				local current_word = vim.fn.expand("<cword>")
				vim.ui.input({ prompt = "새 이름을 입력하세요: ", default = current_word }, function(new_name)
					if not new_name or #new_name == 0 then
						return
					end
					local params = vim.lsp.util.make_position_params()
					params.newName = new_name
					vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, _)
						if err then
							vim.notify("리네임 오류: " .. err.message, vim.log.levels.ERROR)
							return
						end
						vim.lsp.util.apply_workspace_edit(result, "utf-8")
						-- 변경된 모든 버퍼를 저장합니다
						vim.cmd("wall")
					end)
				end)
			end, {})
		end,
	},
}

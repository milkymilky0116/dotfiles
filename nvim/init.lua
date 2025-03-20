local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
require("vim-options")
require("lazy").setup("plugins")

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})

local function toggle_inlay_hint()
	if vim.lsp.inlay_hint then
		-- 현재 Inlay Hint 상태 확인
		local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })

		-- 상태 반전
		vim.lsp.inlay_hint.enable(not is_enabled, { 0 })

		-- 현재 상태를 메시지로 표시
		if is_enabled then
			print("Inlay Hints Disabled")
		else
			print("Inlay Hints Enabled")
		end
	else
		print("Inlay Hint is not supported in this Neovim version")
	end
end

vim.keymap.set("n", "<leader>ih", toggle_inlay_hint, { noremap = true, silent = true })

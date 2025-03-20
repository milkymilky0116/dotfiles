return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"leoluz/nvim-dap-go",
			"nvim-test/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup plugins
			dapui.setup()
			require("dap-go").setup()

			-- Automatically open/close DAP UI when debugging starts/ends
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Key mappings (rest of your existing mappings)
			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "Start debugging" })
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "Step over" })
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "Step into" })
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, { desc = "Step out" })
			vim.keymap.set("n", "<leader>b", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Open REPL" })
			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end, { desc = "Toggle UI" })
		end,
	},
}

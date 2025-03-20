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
        ensure_installed = {
          "lua_ls",
          "nil_ls",
          "gopls",
          "rust_analyzer",
          "ts_ls",
          "denols",
          "svelte",
          "tailwindcss",
        },
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
      local configs = require("lspconfig.configs")

      -- 커스텀 LSP 서버 등록 (이미 등록되어 있지 않은 경우에만)
      if not configs.testlsp then
        configs.testlsp = {
          default_config = {
            cmd = { "/Users/leesungjin/Documents/project/explore-lsp/main" }, -- 실행 파일 경로를 배열로 작성합니다.
            filetypes = { "text" },
            root_dir = function(fname)
              return vim.fn.getcwd() -- 또는 프로젝트에 맞는 root 디렉토리 판별 로직 사용
            end,
            settings = {},
          },
        }
      end
      lspconfig.testlsp.setup({})
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = true,
              telemetry = { enable = false },
              library = {
                "${3rd}/love2d/library",
              },
            },
          },
        },
      })
      lspconfig.nil_ls.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              enable = true,
              typeHints = true, -- 타입 힌트 활성화
              parameterHints = true, -- 매개변수 힌트 활성화
              chainingHints = true, -- 메서드 체이닝 힌트 활성화
            },
          },
        },
      })
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      })
      lspconfig.denols.setup({ capabilities = capabilities })
      lspconfig.svelte.setup({ capabilities = capabilities })
      lspconfig.tailwindcss.setup({ capabilities = capabilities })
      lspconfig.ruff.setup({ capabilities = capabilities })
      lspconfig.ruff_lsp.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.templ.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.htmx.setup({ capabilities = capabilities })
      lspconfig.zls.setup({ capabilities = capabilities })
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

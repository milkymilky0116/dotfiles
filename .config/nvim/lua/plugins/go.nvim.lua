return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup()
  end,
  keys = {
    {
      "<leader>gta",
      function()
        vim.cmd("GoAddTag")
      end,
    },
    {
      "<leader>gtt",
      function()
        vim.cmd("GoTest -v")
      end,
    },
    {
      "<leader>gie",
      function()
        vim.cmd("GoIfErr")
      end,
    },
  },
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
}

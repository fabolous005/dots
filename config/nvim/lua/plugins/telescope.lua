return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    keys = {
      { "<leader>f", "<cmd>Telescope fd hidden=true no_ignore=true<cr>" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>" },
    },
    config = function()
      local trouble = require("trouble.sources.telescope")
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = "close",
              ["<C-c>"] = false,
              ["<C-t>"] = trouble.open,
            },
          },
        },
        extensions = {
          ["fzf"] = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("noice")
      telescope.load_extension("ui-select")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
      },
    },
  },
}

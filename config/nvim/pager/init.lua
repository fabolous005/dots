local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    init = function()
      -- Styles => day, night, moon, storm
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
  {
    "lewis6991/hover.nvim",
    keys = {
      "<C-space>",
      "<C-S-space>",
    },
    config = function()
      require("hover").setup({
        init = function()
          -- require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = nil,
        },
        title = true,
      })

      vim.keymap.set("n", "<C-space>", require("hover").hover)
      vim.keymap.set("n", "<C-S-space>", require("hover").hover_select)
    end,
  },
}, {})

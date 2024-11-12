return {
  {
    "pwntester/octo.nvim",
    config = true,
    cmd = { "Octo" },
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    cmd = { "Git", "G", "Gedit", "Gsplit", "Gedit" },
    dependencies = {
      {
        "f-person/git-blame.nvim",
        cmd = { "GitBlameEnable", "Octo", "GB" },
        opts = {
          enabled = true,
          message_when_not_committed = "     Not yet committed!",
          delay = 300,
        },
      },
      {
        "lewis6991/gitsigns.nvim",
        config = true,
      },
    },
  },
  {

    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
  },
}

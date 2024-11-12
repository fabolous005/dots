require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
  install = {
    missing = true,
    colorscheme = { "tokyonight" },
  },
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "single",
    browser = "librewolf",
  },
  checker = {
    enabled = true,
    notify = true,
    frequency = 3600,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

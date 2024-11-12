return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    -- event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "numToStr/Comment.nvim",
      },
    },
    config = function()
      local configs = require("nvim-treesitter.configs")
      require("ts_context_commentstring").setup()
      configs.setup({
        --[[         context_commentstring = {
          enable = true,
          enable_autocmd = false,
        }, ]]
        ensure_installed = {
          "c",
          "cpp",
          "markdown",
          "rust",
          "regex",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "html",
        },
        sync_install = true,
        ignore_install = {},
        modules = {},
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      })
      require("Comment").setup({
        mappings = { extra = false },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      -- position = "left",
      width = 35,
      padding = false,
      action_keys = {
        toggle_fold = { "<space>" },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { map_bs = false },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "g{" },
      { "g}" },
    },
    event = { "BufReadPost" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "g}", require("todo-comments").jump_next)
      vim.keymap.set("n", "g{", require("todo-comments").jump_prev)
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree" },
    config = true,
    opts = {
      window = {
        width = 35,
        mappings = {
          ["<C-v>"] = "open_vsplit",
          ["<C-x>"] = "open_split",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "sidebar-nvim/sidebar.nvim",
    cmd = { "SidebarNvimToggle" },
    config = function()
      require("sidebar-nvim").setup({
        initial_width = 35,
        sections = {
          "datetime",
          "todos",
          -- "diagnostics",
          "containers",
          "buffers",
          "git",
        },
        datetime = {
          icon = "󱑒 ",
          clocks = {
            { name = "Germany" },
            { name = "Myanmar", offset = "+5.30" },
            { name = "Brasil", offset = "-5" },
          },
        },
        todos = {
          icon = " ",
          initially_closed = false,
        },
        containers = {
          icon = "",
          use_podman = false,
          attach_shell = "/bin/sh",
          show_all = false,
          interval = 5000,
        },
        buffers = {
          icon = "",
          sorting = "name",
          show_numbers = true,
          ignore_not_loaded = false,
          ignore_terminal = false,
        },
      })
    end,
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite" },
  },
  {
    "RaafatTurki/hex.nvim",
    config = true,
    lazy = false,
    cond = function()
      local binary_ext = { "out", "bin", "png", "jpg", "jpeg", "exe", "dll" }
      -- only work on normal buffers
      if vim.bo.ft ~= "" then
        return false
      end
      -- check -b flag
      if vim.bo.bin then
        return true
      end
      -- check ext within binary_ext
      local filename = vim.fn.expand("%:t")
      local ext = vim.fn.expand("%:e")
      if vim.tbl_contains(binary_ext, ext) then
        return true
      end
      -- none of the above
      return false
    end,
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
  },
  -- TODO: this uses kitty protocol, but needs a lot of digging into
  {
    "romgrk/kirby.nvim",
    dependencies = {
      { "romgrk/fzy-lua-native", build = "make" },
      { "romgrk/kui.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-lua/plenary.nvim" },
    },
  },
}

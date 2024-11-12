return {
  {
    "potamides/pantran.nvim",
    cmd = { "Pantran" },
    config = function()
      local actions = require("pantran.ui.actions")
      require("pantran").setup({
        default_engine = "google",
        controls = {
          updatetime = 100,
          mappings = {
            edit = {
              i = {
                ["<C-f>"] = actions.select_target,
                ["<C-d>"] = actions.select_source,
                ["<C-s>"] = actions.switch_languages,
              },
            },
          },
        },
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufRead" },
    config = true,
  },
  {
    -- TODO: add this: https://github.com/b0o/incline.nvim/discussions/32
    "b0o/incline.nvim",
    config = true,
    opts = {
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)

        local buffer = {
          { " ", guibg = "#3b4261" },
          { ft_icon, guifg = ft_color, guibg = "#3b4261" },
          { " ", guibg = "#3b4261" },
          { filename, gui = "bold,italic", guibg = "#3b4261", guifg = "#7aa2f7" },
          { " ", guibg = "#3b4261" },
        }
        return buffer
      end,

      window = {
        margin = {
          horizontal = 0,
          vertical = 0,
        },
        padding = 0,
      },
      hide = { focused_win = true },
    },
    event = { "LspAttach" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufRead" },
    main = "ibl",
    opts = {
      scope = { enabled = true },
    },
  },
  {
    "anuvyklack/windows.nvim",
    event = { "WinNew" },
    opts = {
      autowidth = {
        winwidth = 10,
      },
      animation = { duration = 150 },
    },
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = true,
    enabled = false,
  },
  {
    "axieax/urlview.nvim",
    cmd = { "UrlView" },
    opts = {
      default_picker = "telescope",
      sorted = false,
    },
    config = true,
  },
  {
    "tomiis4/Hypersonic.nvim",
    cmd = "Hypersonic",
    config = true,
  },
  {
    "jbyuki/venn.nvim",
    keys = { "<leader>v" },
    config = function()
      -- venn.nvim: enable or disable keymappings
      function _G.Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd([[setlocal ve=all]])
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true, silent = true })
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true, silent = true })
        else
          vim.cmd([[setlocal ve=]])
          vim.cmd([[mapclear <buffer>]])
          vim.b.venn_enabled = nil
        end
      end
      -- toggle keymappings for venn using <leader>v
      vim.api.nvim_set_keymap("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },
}

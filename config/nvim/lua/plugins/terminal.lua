return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "vertical",
      size = function()
        local tmp = vim.o.columns * 0.3
        if tmp < 50 then
          return 50
        elseif tmp > 80 then
          return 80
        else
          return tmp
        end
      end,
    },
    config = function()
      --[[
      vim.api.nvim_create_autocmd({ "SessionLoadPost", "BufEnter", "BufWinEnter", "WinEnter", "TermOpen", "TermEnter" }, {
        desc = 'Set terminal to insert mode',
        pattern = 'term://*',
        callback = function()
          vim.cmd(':startinsert')
        end,
      })
      ]]
      require("toggleterm").setup({
        direction = "vertical",
        persist_mode = false,
        start_in_insert = true,
        size = function()
          local tmp = vim.o.columns * 0.3
          if tmp < 50 then
            return 50
          elseif tmp > 80 then
            return 80
          else
            return tmp
          end
        end,
      })
    end,
    cmd = { "ToggleTerm" },
    keys = {
      { "<leader>r", "<C-\\><C-n><cmd>ToggleTerm1<cr>", mode = { "t", "n" } },
      { "<leader>t", "<C-\\><C-n><cmd>ToggleTerm2<cr>", mode = { "t", "n" } },
      { "<leader>e", "<C-\\><C-n><cmd>ToggleTerm3 direction=float<cr>", mode = { "t", "n" } },
    },
  },
}

local keys = vim.keymap
local opts = { silent = true }

keys.set("n", "<esc>", "<C-\\><C-n>", opts)
keys.set({ "i", "n", "t" }, "<A-h>", "<C-\\><C-n><C-w>h", opts)
keys.set({ "i", "n", "t" }, "<A-j>", "<C-\\><C-n><C-w>j", opts)
keys.set({ "i", "n", "t" }, "<A-k>", "<C-\\><C-n><C-w>k", opts)
keys.set({ "i", "n", "t" }, "<A-l>", "<C-\\><C-n><C-w>l", opts)

keys.set({ "i", "n", "t" }, "<S-A-h>", "<C-\\><C-n><cmd>vertical resize -2<cr>", opts)
keys.set({ "n", "n", "t" }, "<S-A-j>", "<C-\\><C-n><cmd>resize -2<cr>", opts)
keys.set({ "n", "n", "t" }, "<S-A-k>", "<C-\\><C-n><cmd>resize +2<cr>", opts)
keys.set({ "n", "n", "t" }, "<S-A-l>", "<C-\\><C-n><cmd>vertical resize +2<cr>", opts)

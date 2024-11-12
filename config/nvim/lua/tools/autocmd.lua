local group = vim.api.nvim_create_augroup("LazyPatches", {})
vim.api.nvim_create_autocmd("User", {
  pattern = { "LazyInstall", "LazyUpdate", "LazyCheck" },
  group = group,
  callback = function()
    local patches_path = "/home/fabian/.local/share/nvim/patches/"
    local plugins_path = "/home/fabian/.local/share/nvim/lazy/"
    for patch in vim.fs.dir(patches_path) do
      local plugin = string.match(patch, "^(.-)%-%-")
      if plugin then
        vim.fn.jobstart({ "git", "apply", patches_path .. patch }, { cwd = plugins_path .. plugin })
        -- vim.notify("applied " .. plugin .. " patch")
      else
        vim.notify(patch .. " belongs to no plugin")
      end
    end
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = { "LazyUpdatePre", "LazyCheckPre" },
  group = group,
  callback = function()
    local patches_path = "/home/fabian/.local/share/nvim/patches/"
    local plugins_path = "/home/fabian/.local/share/nvim/lazy/"
    local plugins = {}
    for patch in vim.fs.dir(patches_path) do
      table.insert_unique(plugins, string.match(patch, "^(.-)%-%-"))
    end
    for _, plugin in ipairs(plugins) do
      vim.fn.jobstart({ "git", "stash" }, { cwd = plugins_path .. plugin })
    end
  end,
})

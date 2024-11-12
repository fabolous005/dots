return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
      -- 'WhoIsSethDaniel/lualine-lsp-progress.nvim'
    },
    event = "VeryLazy",
    opts = {
      options = {
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 600,
        },
        theme = "tokyonight",
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 8 },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          -- { "fancy_cwd", substitute_home = true, separator = '' },
          {
            "filename",
            separator = "",
            path = 1,
            symbols = {
              modified = "",
              readonly = "",
              unnamed = "[NAME]",
              newfile = "[NEW]",
            },
            fmt = function(str)
              if string.starts_with(str, "term://") then
                return "Terminal"
              --[[
	      elseif string.starts_with(str, "/") or string.starts_with(str, "~") then
		if #str >= 30 then
		  local startIndex = #str - 30 + 1
		  local result = string.sub(str, startIndex)
	          return result
		end
		return str
	      ]]
              else
                return str
              end
            end,
            -- color = { bg = '#43485E' }
          },
          {
            "navic",
            separator = "",
          },
          { "%=", separator = "" },
          {
            function()
              local buf_clients = vim.lsp.get_clients()
              if #buf_clients == 0 then
                return "LSP Inactive"
              end

              -- add client
              local language_servers = {}
              for _, client in pairs(buf_clients) do
                table.insert(language_servers, client.name)
              end

              local servers = table.concat(language_servers, ", ")
              return " Running LSP: " .. servers
            end,
            color = { gui = "italic,bold", fg = "#ffffff" },
          },
        },
        lualine_x = {
          { "fancy_macro" },
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
          {
            function()
              local stats = require("lazy").stats()
              return stats.loaded .. "/" .. stats.count .. "  "
            end,
            color = { fg = "#cd5c5c" },
          },
          {
            function()
              local stats = require("lazy").stats()
              return stats.startuptime
            end,
            color = { fg = "#ffbf1f" },
            fmt = function(str)
              return str:sub(1, 5) .. "ms 󱐋"
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_y = {
          {
            function()
              -- if vim.fn.filereadable(vim.fn.expand("%:p")) then
              local file = vim.fn.expand("%:p")
              local f = io.open(file, "r")
              if f ~= nil and not string.containsSpaces(f) then
                io.close(f)
                local octal = io.popen('stat -c "%a" ' .. vim.fn.expand("%:p"))
                local user = io.popen('stat -c "%U" ' .. vim.fn.expand("%:p"))
                local group = io.popen('stat -c "%G" ' .. vim.fn.expand("%:p"))
                local foctal
                local fuser
                local fgroup
                if octal ~= nil then
                  foctal = octal:read("a"):sub(1, -2)
                end
                if user ~= nil then
                  fuser = user:read("a"):sub(1, -2)
                end
                if group ~= nil then
                  fgroup = group:read("a"):sub(1, -2)
                end
                if fuser == fgroup then
                  if octal and user and group ~= nil then
                    user:close()
                    group:close()
                    octal:close()
                    return foctal .. " " .. fuser
                  end
                end
                if octal and user and group ~= nil then
                  user:close()
                  group:close()
                  octal:close()
                end
                return foctal .. " " .. fuser .. ":" .. fgroup
              else
                return ""
              end
            end,
          },
          { "fileformat" },
          { "fancy_filetype" },
          { "progress" },
        },
        lualine_z = {
          { "fancy_location" },
        },
      },
      -- extensions = { 'quickfix' }
    },
  },
}

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "LspAttach", "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "nat-418/cmp-color-names.nvim",
      {
        "zbirenbaum/copilot-cmp",
        config = true,
      },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        enabled = false,
      },
    },
    config = function()
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      cmp.setup({
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        formatting = {
          fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
          format = function(_, item)
            local icons = require("config.variables").icons.kinds
            if icons[item.kind] then
              item.kind = " " .. icons[item.kind][1] .. " "
              -- item.abbr_hl_group = "CmpItemKind" .. item.kind
            end
            return item
          end,
        },

        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "copilot" },
          --[[
          {
            name = "cmp_tabnine",
            -- INFO: fixed with autocmd after cmp setup
                         option = {
              ignored_file_types = {
                TelescopePrompt = true,
              },
            },
          },]]
          { name = "calc" },
          {
            name = "path",
            option = {
              trailing_slash = true,
            },
          },
          { name = "color_names" },
          { name = "crates" },
        },

        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local entry = cmp.get_selected_entry()
              if not entry then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.confirm()
              end
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-Space>"] = cmp.mapping.complete(),
        },
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "TelescopePrompt" },
        callback = function()
          cmp.setup.buffer({ completion = { autocomplete = false } })
        end,
      })
    end,
  },
}

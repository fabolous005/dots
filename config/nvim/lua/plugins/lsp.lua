return {
  "folke/neodev.nvim",
  "simrat39/rust-tools.nvim",
  "p00f/clangd_extensions.nvim",
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_compiler_method = "tectonic"
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    build = function()
      require("typst-preview").update()
    end,
    config = {
      debug = true,
      dependencies_bin = {
        ["typst-preview"] = nil,
        -- ['websocat'] =
      },
      open_cmd = "librewolf %s --class typst-preview",
      -- open_cmd = "librewolf %s -P typst-preview --class typst-preview",
      root_dir = function()
        vim.fn.getcwd()
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePre", "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters.dotenv = {
        name = "dotenv-linter",
        cmd = "dotenv-linter",
        stdin = true,
        args = { "--recursive" },
      }
      local shellcheck = lint.linters.shellcheck
      shellcheck.args = {
        "--external-sources",
      }

      lint.linters_by_ft = {
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        css = { "stylelint" },
        cmake = { "cmakelint" },
        dockerfile = { "hadolint" },
        sh = { "shellcheck" },
        lua = { "selene" },
        go = { "revive" },
        markdown = { "vale" },
        json = { "jsonlint" },
        yaml = { "yamllint" },
        -- html = { "erb_lint" },
        latex = { "vale", "cspell" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        python = { "flake8" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
          css = { "prettier" },
          cmake = { "cmake_format" },
          -- INFO: disabled due to too offensive fixes
          -- sh = { "shellharden" },
          lua = { "stylua" },
          go = { "gofumpt", "goimports" },
          markdown = { "markdownlint", "prettier" },
          json = { "jq", "prettier" },
          yaml = { "yamlfmt", "prettier" },
          html = { "rustywind", "prettier" },
          toml = { "taplo" },
          typst = { "typstfmt" },
          latex = { "bibtex-tidy", "latexindent" },
          javascript = { "rustywind", "prettier" },
          typescript = { "rustywind", "prettier" },
          python = { "isort", "black" },
        },
      })

      local format_augroup = vim.api.nvim_create_augroup("format", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = format_augroup,
        callback = function()
          conform.format({
            async = true,
          })
          vim.cmd([[:write]])
        end,
      })
    end,
  },
  {
    -- TODO: setup cmp
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        avoid_prerelease = true,
        open_programs = { "xdg-open" },
        null_ls = {
          enabled = false,
        },
        popup = {
          autofocus = true,
        },
        src = {
          cmp = {
            enabled = true,
          },
        },
      })
      local crates = require("crates")
      local opts = { silent = true }
      vim.keymap.set("n", "<leader>c", crates.show_popup, { silent = true, nowait = true })
      vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
      vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
      vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)
    end,
  },
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    config = true,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
  },
  {
    -- WARN: not useful enough and no good default icons
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
    opts = {
      keymaps = {
        toggle_preview = "f",
      },
    },
    config = true,
    enabled = false,
  },
  {
    -- WARN: causes bugs
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "LspAttach" },
    config = true,
    enabled = false,
  },
  {
    "aznhe21/actions-preview.nvim",
    cmd = { "CA" },
    event = { "LspAttach" },
    config = function()
      require("actions-preview").setup({
        diff = {
          ctxlen = 5,
        },
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      })
      vim.api.nvim_create_user_command("CA", 'lua require("actions-preview").code_actions()', {})
      vim.keymap.set({ "n", "v" }, "<leader>a", require("actions-preview").code_actions)
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = { "LspAttach" },
    config = function()
      vim.api.nvim_set_hl(0, "LightBulbCustom", { fg = "#ffff00" })
      require("nvim-lightbulb").setup({
        autocmd = {
          enabled = true,
        },
        link_highlights = true,
        sign = {
          text = " ",
          hl = "LightBulbCustom",
        },
        validate_config = "never",
      })
    end,
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
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          -- require("hover.providers.man")
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
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "LspAttach",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    -- enabled = false,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = " ",
          package_pending = "󰦗 ",
          package_uninstalled = " ",
        },
      },
      log_level = vim.log.levels.DEBUG,
    },
    dependencies = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("mason-tool-installer").setup({
            -- TODO: review which of these can be installed globally via the packagemanager
            ensure_installed = {
              -- Linter
              "selene",
              "flake8",
              "eslint",
              "hadolint",
              "shellcheck",
              "vale",
              -- "erb-lint",
              "cmakelint",
              "yamllint",
              "jsonlint",
              "revive",

              -- Formatter
              "prettier",
              "cmakelang",
              "clang-format",
              "shellharden",
              "gofumpt",
              "goimports",
              "isort",
              "black",
              "bibtex-tidy",
              "typstfmt",
              "stylua",
              "stylelint",
              "latexindent",
              "markdownlint",
              "yamlfmt",
              "rustywind",

              -- Dap
              "bash-debug-adapter",
              "codelldb",
              "debugpy",
            },
            auto_update = true,
          })
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      -- Mason
      {
        "williamboman/mason-lspconfig.nvim",
      },
      {
        "SmiteshP/nvim-navic",
        opts = { highlight = true, depth_limit = 5 },
      },
    },
    config = function()
      require("neodev").setup({
        library = {
          plugins = { "nvim-dap-ui" },
          types = true,
        },
      })
      local rt = require("rust-tools")
      -- TODO: review additional configuration options
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
      local servers = {
        { "bashls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        {
          "clangd",
          settings = {},
          init_options = {},
          on_attach = function()
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
          end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        { "neocmake", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "dockerls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        {
          "rust_analyzer",
          settings = {},
          init_options = {},
          on_attach = nil,
          func = function()
            rt.setup({
              tools = {
                executor = require("rust-tools.executors").toggleterm,
              },
              server = {
                standalone = false,
                settings = {
                  ["rust-analyzer"] = {
                    checkOnSave = {
                      command = "clippy",
                      enable = true,
                    },
                    cargo = {
                      allFeatures = true,
                    },
                  },
                },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
              },
            })
          end,
        },
        { "zls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "jsonls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "lua_ls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "gopls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "marksman", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "pyright", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "taplo", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "jdtls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "yamlls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        { "dotls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        -- { "nimls", settings = {}, init_options = {}, capabilities = require("cmp_nvim_lsp").default_capabilities() },
        {
          "diagnosticls",
          settings = {},
          init_options = {},
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        {
          "docker_compose_language_service",
          settings = {},
          init_options = {},
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        {
          "texlab",
          settings = {
            texlab = {
              latexFormatter = "none",
              build = {
                onSave = true,
                executable = "tectonic",
                args = {
                  "-X",
                  "compile",
                  "%f",
                  "--synctex",
                  "--keep-logs",
                  "--keep-intermediates",
                },
              },
            },
          },
          init_options = {},
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        {
          "typst_lsp",
          settings = {},
          init_options = {
            -- TODO: make this use normal mode
            -- HACK: this makes the lsp use single-file-mode
            root_dir = vim.loop.cwd(),
          },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
      }

      local ei_server = {}
      for _, server in ipairs(servers) do
        if server == "rust_analyzer" then
          table.insert(ei_server, server[1])
        end
      end
      require("mason-lspconfig").setup({
        ensure_installed = ei_server,
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      for _, server in ipairs(servers) do
        if server.func ~= nil and type(server.func) == "function" then
          server.func(server[2] or nil, server[3] or nil, server[4] or nil)
        else
          lspconfig[server[1]].setup({
            settings = server.settings or nil,
            init_options = server.init_options or nil,
            on_attach = server.on_attach or nil,
          })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local navic = require("nvim-navic")
          if client ~= nil then
            if navic.is_available and client.name ~= "diagnosticls" and client.name ~= "copilot" then
              navic.attach(client, bufnr)
            end
          end

          require("lsp_signature").on_attach({ noice = true, hint_prefix = " " }, bufnr)

          local opts = { buffer = bufnr }
          -- TODO: review and learn mappings
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })
    end,
  },
}

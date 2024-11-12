return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      "<leader>ds",
      "<leader>di",
      "<leader>do",
      "<leader>db",
      "<leader>da",
      "<leader>df",
      "<leader>de",
      "<leader>dd",
    },
    config = function()
      local dap = require("dap")
      require("dapui").setup()
      local dapui = require("dapui")

      local file_exists = function(name)
        local f = io.open(name, "r")
        if f ~= nil then
          io.close(f)
          return true
        else
          return false
        end
      end

      local get_program = function()
        local cwd = vim.fn.getcwd()
        local dir = vim.fn.fnamemodify(cwd, ":t")
        local program
        if file_exists(cwd .. "/" .. dir) then
          program = cwd .. "/" .. dir
        elseif file_exists(cwd .. "/build/" .. dir) then
          program = cwd .. "/build/" .. dir
        elseif file_exists(cwd .. "/target/debug/" .. dir) then
          if file_exists("Cargo.toml") then
            vim.cmd("!cargo build")
          end
          program = cwd .. "/target/debug/" .. dir
        else
          --[[           local build_dir
          if file_exists("Cargo.toml") then
            build_dir = "target/debug/file"
          elslocal dapui = e
            build_dir = "file"
          end ]]
          -- TODO: this is no good at all
          -- INFO: idea -> if this point is reached create an user command that creates the config and reload dap
          -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", build_dir)
          return
        end
        vim.notify("Found executable on: " .. program)
        return program
      end

      -- Python setup
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
              source_filetype = "python",
            },
          })
        else
          cb({
            type = "executable",
            command = "/home/fabian/.local/share/nvim/mason/packages/debugpy/debugpy",
            args = { "-m", "debugpy.adapter" },
            options = {
              source_filetype = "python",
            },
          })
        end
      end
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",

          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "/usr/bin/python3.11"
            end
          end,
        },
      }

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        host = "127.0.0.1",
        executable = {
          command = "/home/fabian/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
          args = {
            "--liblldb",
            "/home/fabian/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so",
            "--port",
            "${port}",
          },
        },
      }
      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = get_program(),
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          program = get_program(),
          stopOnEntry = false,
          cwd = "${workspaceFolder}",
          showDisassembly = "never",
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host, port = config.port })
      end
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = "127.0.0.1",
          port = "8031",
        },
      }

      dap.adapters.bashdb = {
        type = "executable",
        command = "/home/fabian/.local/share/nvim/mason/packages/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
      }
      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = "/home/fabian/.local/share/nvim/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = "/home/fabian/.local/share/nvim/mason/packages/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "/bin/cat",
          pathBash = "/bin/bash",
          pathMkfifo = "/usr/bin/mkfifo",
          pathPkill = "/usr/bin/pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }

      vim.keymap.set("n", "<leader>dc", function()
        if vim.bo.filetype == "lua" then
          require("osv").run_this()
        else
          dap.continue()
        end
      end)
      vim.keymap.set("n", "<leader>ds", dap.step_over)
      vim.keymap.set("n", "<leader>di", dap.step_into)
      vim.keymap.set("n", "<leader>do", dap.step_out)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>da", dap.clear_breakpoints)

      vim.keymap.set("n", "<leader>df", dapui.float_element)
      vim.keymap.set("n", "<leader>de", dapui.eval)
      vim.keymap.set("n", "<leader>dd", dapui.toggle)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- This closes dapui even when program panics
      --[[       dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end ]]
      --[[       dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end ]]

      vim.fn.sign_define("DapBreakpoint", {
        text = " ",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = " ",
        texthl = "DapLogPoint",
        linehl = "DapLogPointLine",
        numhl = "DapLogPointNum",
      })
      vim.fn.sign_define("DapStopped", {
        text = " ",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedNum",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = " ",
        texthl = "DapBreakpointCondition",
        linehl = "DapBreakpointConditionLine",
        numhl = "DapBreakpointConditionNum",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = " ",
        texthl = "DapBreakpointRejected",
        linehl = "DapBreakpointRejectedLine",
        numhl = "DapBreakpointRejectedNum",
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    main = "osv",
  },
  {
    "nvim-neotest/neotest",
    keys = {
      "<leader>sr",
      "<leader>sf",
      "<leader>sw",
      "<leader>sa",
      "<leader>sa",
      "<leader>sd",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-rust")({
            dap_adapter = "codelldb",
          }),
        },
      })
      local neotest = require("neotest")
      vim.keymap.set("n", "<leader>sr", neotest.output_panel.toggle)
      vim.keymap.set("n", "<leader>sf", neotest.output.toggle)
      vim.keymap.set("n", "<leader>sw", neotest.watch.toggle)
      vim.keymap.set("n", "<leader>ss", neotest.run.run())
      vim.keymap.set("n", "<leader>sa", function()
        neotest.run.run(vim.fn.expand("%"))
      end)
      vim.keymap.set("n", "<leader>sd", function()
        neotest.run.run({ strategy = "dap" })
      end)
    end,
    dependencies = {
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      local cover = require("coverage")
      cover.setup({
        auto_reload = true,
        commands = false,
      })
      vim.api.nvim_create_user_command("Coverage", function()
        cover.load({ place = true })
      end)
    end,
  },
}

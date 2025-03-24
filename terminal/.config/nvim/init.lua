-- 1. Set Theme
vim.cmd("colorscheme gruvbox")

-- 2. Config Statusline (lualine.nvim)
require("lualine").setup {
  options = { theme = "gruvbox" }
}

-- 3. Config File Explorer (nvim-tree)
require("nvim-tree").setup {}

-- 4. Config Dashboard (Start Screen)
require("dashboard").setup {
  theme = "doom",
  config = {
    header = { "Welcome to Neovim 🚀" },
  }
}

-- 5. Config Indent (indent-blankline.nvim)
require("ibl").setup {
  indent = { char = "│" },
  scope = { enabled = true },
}

-- 6. Config Cursor Animation
require("nvim-cursorline").setup {}

-- 7. Using the flutter-tools plugin
require('flutter-tools').setup {
  flutter_path = "/home/nbs/Development/flutter/bin/flutter",  -- Update this path

  debugger = {
    enabled = true,  -- Enable debugging
    run_via_dap = true,
    register_configurations = function(_)
      require("dap").adapters.dart = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
        args = { "flutter" }
      }

      require("dap").configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          dartSdkPath = "/home/nbs/Development/flutter/bin/cache/dart-sdk/",
          flutterSdkPath = "/home/nbs/Development/flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        }
      }
    end,
  },

  dev_log = {
    enabled = true,
    open_cmd = "tabedit",
  },

  lsp = {
    -- Define LSP capabilities manually
    capabilities = vim.lsp.protocol.make_client_capabilities(), 

    -- on_attach function
    on_attach = function(client, bufnr)
      -- You can add custom configurations and keymaps here
      require("lspconfig").common_on_attach(client, bufnr)
    end,
  },
}

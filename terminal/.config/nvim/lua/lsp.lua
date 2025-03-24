require("flutter-tools").setup {
  lsp = {
    on_attach = function(client, bufnr)
      vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  },
}

require("lspconfig").dartls.setup {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

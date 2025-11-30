-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({})
require('lspconfig').rust_analyzer.setup({
  -- optionally pass settings:
  settings = { ["rust-analyzer"] = {} }
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({})
require("lspconfig").rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        -- or: sysroot = nil / unset
      },
      imports = {
        preferNoStd = true,         -- prefer core/alloc over std
      },
    },
  },
})

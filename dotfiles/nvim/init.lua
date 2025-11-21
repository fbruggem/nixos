-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({})
lspconfig.rust_analyzer.setup {
  cmd = { "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        disabled = { "inactive-code" },
        enable = true
      }
    }
  }
}
-- Disable underlines for LSP diagnostics
vim.diagnostic.config({
  underline = false,   -- removes wavy/straight underlines
  virtual_text = true, -- optional: keep error messages in gutter
  signs = true,        -- keep signs in the sign column
})

-- Remove syntax or spell underlines
vim.cmd [[
  highlight! DiagnosticUnderlineError gui=NONE
  highlight! DiagnosticUnderlineWarn  gui=NONE
  highlight! DiagnosticUnderlineInfo  gui=NONE
  highlight! DiagnosticUnderlineHint  gui=NONE
  highlight! SpellBad gui=NONE
  highlight! SpellCap gui=NONE
  highlight! SpellLocal gui=NONE
  highlight! SpellRare gui=NONE
]]

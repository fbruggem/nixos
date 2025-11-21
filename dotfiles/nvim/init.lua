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
  underline = false,   -- removes LSP underlines
  virtual_text = true, -- optional: keep inline error messages
  signs = true,        -- keep gutter signs
})

-- Remove highlight underlines completely (Neovim 0.10+)
local groups = {
  "DiagnosticUnderlineError",
  "DiagnosticUnderlineWarn",
  "DiagnosticUnderlineInfo",
  "DiagnosticUnderlineHint",
  "SpellBad",
  "SpellCap",
  "SpellLocal",
  "SpellRare"
}

for _, group in ipairs(groups) do
  vim.api.nvim_set_hl(0, group, { underline = false, undercurl = false })
end

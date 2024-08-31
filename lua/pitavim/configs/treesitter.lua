local options = {
  ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
  vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  })
}

return options

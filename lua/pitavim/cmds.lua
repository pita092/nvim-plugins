local autocmd = vim.api.nvim_create_autocmd

autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})

autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name("NvFilePost")

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.opt_local.fillchars:append({ eob = " " })
  end,
})

vim.defer_fn(function()
  vim.cmd([[
    highlight SignColumn guibg=NONE ctermbg=NONE
  ]])
end, 100)

vim.cmd([[
  colorscheme gruvbox
  highlight Normal guibg=#282828
  ]])

vim.cmd([[
  highligh  TelescopePromptBorder guibg=#504945
  highligh  TelescopePromptBorder guifg=#504945
  highlight TelescopePromptNormal guibg=#504945
  highlight TelescopeNormal guibg=#3c3836
  highlight TelescopeNormal guifg=#fbf1c7
  highlight TelescopeSelection guibg=#7c6f64
  highlight  TelescopePromptPrefix guifg=#b8bb26
  highlight TelescopeMatching guifg=#fabd2f
  highlight Pmenu guibg=#3c3836
  highlight 	TelescopePromptTitle guibg=#3c3836
  highlight 	TelescopePromptTitle guifg=#3c3836
  highlight 	TelescopeBorder guifg=#fbf1c7
  highlight 	TelescopeBorder guibg=#fbf1c7
  ]])

---custom commands

vim.api.nvim_create_user_command("Updt", "Lazy update nvim-plugins", {
  desc = "Update neovim plugins",
})
vim.cmd([[
  function! LuaAbbreviation()
    let cmd = getcmdline()
    if cmd =~ '\v\C^(lua\s+)@!'
      return 'lua'
    endif
    return '🌙'
  endfunction

  cabbrev <expr> lua LuaAbbreviation()
]])

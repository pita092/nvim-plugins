require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua", "luaformatter" },
		c = { "clang_format" },
		cpp = { "clang_format" },

		formatters_by_ft = {
			go = { "gofumpt", "goimports", "golines" },
		},
		format_on_save = {
			lsp_fallback = true,
		},
	},
})

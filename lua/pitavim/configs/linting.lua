local lint = require("lint")

lint.linters_by_ft = {
	lua = { "luacheck" },
	latex = { "vale" },
}
require("lint").linters.luacheck.args = {
	"--globals",
	"vim",
	"--no-max-line-length",
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Toggle linting for current buffer" })

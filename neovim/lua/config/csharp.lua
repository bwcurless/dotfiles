-- Set up make program
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		local sln_file = vim.fn.glob("*.sln") -- Check for .sln file in the current directory
		if sln_file ~= "" then
			vim.opt.makeprg = "dotnet build " .. sln_file .. " /p:Configuration=Debug"
			print("Makeprg set to build solution: " .. sln_file)
		end
	end,
})

-- Command to transform Xaml properties into Setters
vim.api.nvim_create_user_command("XmlToSetter", function(opts)
	local line1 = opts.line1
	local line2 = opts.line2

	-- Construct and run the substitution command on the given range
	vim.cmd(string.format(
		[[%d,%ds/\v(^\s*)(\S+)=(".*")/\1<Setter Property="\2" Value=\3 \/>/]],
		line1, line2
	))
end, {
	range = true,
	desc = "Convert XML property lines into WPF Setter elements"
})

vim.api.nvim_create_user_command("Makecs", function(opts)
	vim.cmd("make!")
	vim.cmd("silent! redraw!")
	local all = vim.fn.getqflist()
	local only_errors = vim.tbl_filter(function(item)
		return item.type == 'e'
	end, all)

	-- Because we dual build, we duplicate most errors.
	local seen = {}
	local deduped_errors = {}

	for _, item in ipairs(only_errors) do
		local key = string.format("%s:%d:%d", item.filename or item.bufnr, item.lnum, item.col)
		if not seen[key] then
			seen[key] = true
			table.insert(deduped_errors, item)
		end
	end

	vim.fn.setqflist(deduped_errors, 'r') -- Replace current qflist

	if vim.fn.getqflist({ size = 0 }).size > 0 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end, { desc = "Make CSharp solution, filter out warnings" })

local lspConfig = require('config.lsp')

-- Only bind this up if filetype is csharp.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.keymap.set("n", "<leader>gf", function() lspConfig.filter_code_action_by_title("Generate field") end,
			{ desc = "Generate field for parameter under cursor", buffer = true })
	end
})

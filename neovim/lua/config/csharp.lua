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

vim.api.nvim_create_user_command("Makecs", function(opts)
	vim.cmd("make!")
	vim.cmd("silent! redraw!")
	local all = vim.fn.getqflist()
	local only_errors = vim.tbl_filter(function(item)
		return item.type == 'e'
	end, all)

	vim.fn.setqflist(only_errors, 'r') -- Replace current list with filtered entries

	if vim.fn.getqflist({ size = 0 }).size > 0 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end, { desc = "Make CSharp solution, filter out warnings" })

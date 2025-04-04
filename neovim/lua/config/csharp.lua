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

-------------------
--- Terminal setup
-------------------
vim.keymap.set({ 't' }, '<Esc><Esc>', '<C-\\><C-n>', { desc = "Easily escape terminal mode" })

--Configure terminal when it is opened
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false })
	end
})

-- Switch to term mode if navigating to a buffer with a term type buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function(args)
		local buftype = vim.bo[args.buf].buftype
		if buftype == "terminal" then
			print("Entered terminal buffer: " .. args.buf)
			vim.api.nvim_command("startinsert")
		end
	end
})

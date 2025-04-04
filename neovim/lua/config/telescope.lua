-----------------------
--- Telescope setup
----------------------
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	}
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

-- Keymaps
-- Note look at on LspAttach event to see more Telescope bindings
vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep working directory' })
vim.keymap.set('n', '<leader>fc', builtin.grep_string,
	{ desc = 'Telescope grep string under cursor in working directory' })
vim.keymap.set("n", "<leader>fl", function()
	require('telescope.builtin').live_grep({
		prompt_title = "Search through plugins",
		cwd = vim.fn.stdpath("data") .. "/plugged",
		extensions = { "lua" }
	})
end, { desc = "Find Lua files" })

-- Commands (I use these less frequently)
vim.api.nvim_create_user_command('Maps', function()
	builtin.keymaps()
end, { desc = 'Telescope keymaps' })
vim.api.nvim_create_user_command('Help', function()
	builtin.help_tags()
end, { desc = 'Telescope help tags' })
vim.api.nvim_create_user_command('Qf', function()
	builtin.quickfix()
end, { desc = 'Telescope quickfix list' })
vim.api.nvim_create_user_command('Reg', function()
	builtin.registers()
end, { desc = 'Telescope registers' })
vim.api.nvim_create_user_command('Commits', function()
	builtin.git_commits()
end, { desc = 'Telescope git commits' })
vim.api.nvim_create_user_command('BCommits', function()
	builtin.git_bcommits()
end, { desc = 'Telescope git commits on this buffer' })

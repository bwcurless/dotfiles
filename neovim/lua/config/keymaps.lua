--------------------
-- Assorted Keymaps
--------------------
-- These don't warrant their own file.

-- My little terminal plugin to toggle a persistent terminal on/off
local togTerm = require('myPlugins.toggleterm')
vim.keymap.set('n', "<leader>st", togTerm.toggleTerminal,
	{ desc = "Toggle bottom persistent terminal on/off", silent = true })

-- My plugin to reorder arguments in a definition, or usage
local argreor = require("myPlugins.argreorderer")

vim.keymap.set('n', '<leader>al', argreor.swap_argument_left,
	{ desc = "Shift argument left", silent = true })
vim.keymap.set('n', '<leader>ar', argreor.swap_argument_right,
	{ desc = "Shift argument right", silent = true })

-- Persist the last time we opened a terminal and allow it to be toggled
-- open and closed

M = {}

local state = {
	-- -1 for values since nil isn't a valid buf/win number
	buf = -1,
	win = -1,
}

local function open_bottom_split_window(opts)
	opts = opts or {}
	opts.buf = opts.buf or -1

	-- Create an empty buffer if none was passed in
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win = vim.api.nvim_open_win(buf, true, { split = "below" })
	vim.api.nvim_win_set_height(win, 10)

	return { buf = buf, win = win }
end

-- Main toggle terminal method
local function toggleTerminal()
	-- Close window if currently open
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
	else
		-- Open a new terminal and a new window
		if not vim.api.nvim_buf_is_valid(state.buf) then
			state = open_bottom_split_window()
			vim.cmd.terminal()
		else
			-- Open the existing terminal buffer
			state = open_bottom_split_window(state)
			-- When we navigate back, make sure we are in insert mode
			vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false })
		end
	end
end

M.toggleTerminal = toggleTerminal

return M

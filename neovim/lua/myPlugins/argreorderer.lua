-------------------
--- Argument reorderer "( ... , ... , ... )"
--- 		          -->	<--
-------------------
local M = {}

local function swap_strings_on_lines(str1, row1, str2, row2)
	-- Multi line argument lists
	if row1 ~= row2 then
		local line1 = vim.api.nvim_buf_get_lines(0, row1, row1 + 1, true)[1]
		print(vim.inspect(line1))
		local temp1 = line1:gsub(vim.pesc(str1), str2, 1)
		vim.api.nvim_buf_set_lines(0, row1, row1 + 1, true, { temp1 })

		local line2 = vim.api.nvim_buf_get_lines(0, row2, row2 + 1, true)[1]
		print(vim.inspect(line2))
		local temp2 = line2:gsub(vim.pesc(str2), str1, 1)
		vim.api.nvim_buf_set_lines(0, row2, row2 + 1, true, { temp2 })
		-- Single line argument lists
	else
		local line = vim.api.nvim_buf_get_lines(0, row1, row1 + 1, true)[1]
		-- Replace first occurrence of str1 with a placeholder
		local temp = line:gsub(vim.pesc(str1), "TEMP_SWAP_PLACEHOLDER", 1)
		-- Replace first occurrence of str2 with str1
		temp = temp:gsub(vim.pesc(str2), str1, 1)
		-- Replace placeholder with str2
		temp = temp:gsub("TEMP_SWAP_PLACEHOLDER", str2, 1)

		vim.api.nvim_buf_set_lines(0, row1, row1 + 1, true, { temp })
	end
end

local function is_cursor_on_node(node)
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	local start_row, start_col, end_row, end_col = node:range()

	cursor_row = cursor_row - 1
	-- Check if the cursor is inside this argument's range
	if cursor_row >= start_row and cursor_row <= end_row and cursor_col >= start_col and cursor_col <= end_col then
		return true
	else
		return false
	end
end


local function is_swappable_parent(node)
	if node:type() == "argument_list"
	    or node:type() == "arguments"
	    or node:type() == "parameters"
	    or node:type() == "parameter_list"
	    or node:type() == "type_argument_list" then
		return true
	else
		return false
	end
end

local function is_swappable_item(node)
	if node:type() == "argument"
	    or node:type() == "parameter"
	    or node:type() == "string"
	    or node:type() == "identifier" then
		return true
	else
		return false
	end
end

local function get_parentheses_node_around_cursor()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	while node do
		if is_swappable_parent(node) then
			print("node is: " .. node:type())
			return node
		end
		node = node:parent()
	end
	return nil
end

local function swap_argument_right()
	local node = get_parentheses_node_around_cursor()
	if not node then
		print("Cursor is not inside parentheses!")
		return
	end

	local left_arg, left_row = nil, nil
	for child in node:iter_children() do
		if is_swappable_item(child) then
			local arg_text = vim.treesitter.get_node_text(child, 0)
			if is_cursor_on_node(child) then
				left_arg = arg_text
				left_row, _, _, _ = child:range()
			elseif left_arg ~= nil then
				local right_arg = arg_text
				local right_row, _, _, _ = child:range()
				-- Swap the two
				swap_strings_on_lines(left_arg, left_row, right_arg, right_row)
				-- Shift the cursor back to where it was before
				local escape_str = vim.pesc(left_arg)
				vim.fn.search(escape_str)

				return
			end
		end
	end
	print("Can't shift, already rightmost argument")
end

local function swap_argument_left()
	local node = get_parentheses_node_around_cursor()
	if not node then
		print("Cursor is not inside parentheses!")
		return
	end

	local left_arg, left_row = nil, nil
	for child in node:iter_children() do
		if is_swappable_item(child) then
			local arg_text = vim.treesitter.get_node_text(child, 0)
			if is_cursor_on_node(child) then
				if (not left_arg) then
					print("Can't shift, already leftmost argument")
					return
				end

				local right_arg = arg_text
				local right_row = child:range()
				-- Swap the two
				swap_strings_on_lines(left_arg, left_row, right_arg, right_row)
				-- Shift the cursor back to where it was before
				local escape_str = vim.pesc(right_arg)
				vim.fn.search(escape_str, 'b')

				return
			else
				-- Update left argument
				left_arg = arg_text
				left_row, _, _, _ = child:range()
			end
		end
	end
end

M.swap_argument_left = swap_argument_left
M.swap_argument_right = swap_argument_right

return M

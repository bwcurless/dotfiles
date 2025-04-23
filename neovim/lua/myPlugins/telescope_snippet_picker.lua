local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local snippet_dir = vim.fn.stdpath("config") .. "/UltiSnips"

local function read_snippet_file(file)
	local lines = {}
	local f = io.open(file, "r")
	if not f then return lines end
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()
	return lines
end

local function find_snippets(ft)
	local results = {}
	local scan = require("plenary.scandir")
	local files = scan.scan_dir(snippet_dir, {
		depth = 1,
		search_pattern = "%.snippets$"
	})

	for _, file in ipairs(files) do
		local filename = vim.fn.fnamemodify(file, ":t")
		local target_ft = filename:match("^(.*)%.snippets$")

		-- Filter by exact match or "all"
		if target_ft == ft or target_ft == "all" then
			local lines = read_snippet_file(file)
			for i, line in ipairs(lines) do
				local trigger, description = line:match("^snippet%s+([%w_%-]+)%s*(.*)")
				if trigger then
					table.insert(results, {
						filename = file,
						lnum = i,
						trigger = trigger,
						description = description or "",
						display = string.format("%-20s %s", trigger, description),
					})
				end
			end
		end
	end

	return results
end

-- Pull full snippet body
local function extract_snippet_body(file, start_line)
	local lines = read_snippet_file(file)
	local body = {}
	for i = start_line + 1, #lines do
		local line = lines[i]
		if line:match("^endsnippet") then break end
		table.insert(body, line)
	end
	return body
end

-- Snippet previewer
local snippet_previewer = previewers.new_buffer_previewer({
	define_preview = function(self, entry)
		local body = extract_snippet_body(entry.filename, entry.lnum)
		vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, body)
	end,
})

-- Insert snippet into the current buffer
local function insert_snippet(entry)
	local body = extract_snippet_body(entry.filename, entry.lnum)
	vim.api.nvim_put(body, "l", true, true)
end

local M = {}

function M.pick_snippet()
	local ft = vim.bo.filetype
	local entries = find_snippets(ft)

	if #entries == 0 then
		vim.notify("No snippets found for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	pickers.new({}, {
		prompt_title = "UltiSnips Snippets",
		finder = finders.new_table({
			results = entries,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry.display,
					ordinal = entry.trigger .. " " .. entry.description,
					filename = entry.filename,
					lnum = entry.lnum,
				}
			end,
		}),
		previewer = snippet_previewer,
		sorter = conf.generic_sorter({}),
		attach_mappings = function(_, map)
			map("i", "<CR>", function()
				local selection = action_state.get_selected_entry()
				actions.close()
				insert_snippet(selection.value)
			end)
			return true
		end,
	}):find()
end

return M

--------------------
-- Globals
--------------------

function Which_host()
	local hostname = vim.loop.os_gethostname()

	if vim.startswith(hostname, "WL-G7M2MN3") then
		return "work"
	end
	if vim.startswith(hostname, "Brians-Laptop") or vim.startswith(hostname, "Mac") then
		return "macbook"
	end
	return "unknown"
end

function P(table)
	print(vim.inspect(table))
end

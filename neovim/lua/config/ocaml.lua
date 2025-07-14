-- set rtp^="/Users/briancurless/.opam/cs3110-2025sp/share/ocp-indent/vim"
vim.opt.runtimepath:prepend("/Users/briancurless/.opam/cs3110-2025sp/share/ocp-indent/vim")

-- Note that npairs must be setup before this is run.

-- In Ocaml, autopair on ' is annoying because we commonly type 'a, 'b, etc
local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')
---- Remove the default single quote rule first
npairs.remove_rule("'")
--
---- Add a new single quote rule with a condition to disable pairing in ocaml files
npairs.add_rules({ Rule("'", "'")
    :with_pair(function(opts)
	    local ft = vim.bo.filetype
	    if ft == "ocaml" then
		    return false -- disable pairing in OCaml buffers
	    end
	    -- Otherwise, allow pairing
	    return true
    end) }
)

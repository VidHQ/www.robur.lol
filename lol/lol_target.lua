--[[ LOL BOOTSTRAP MODULES ]]--
require("lol.lol_cdefs")
require("lol.lol_offsets")
require("lol.lol")

-- append some stuff to global printHelp()
local printHelpGlobal = _G.printHelp;
function _G.printHelp()
	printHelpGlobal()
	print 'Some [lol] Commands:                                                 '
	print '----------------------------------------------------------------------'
end

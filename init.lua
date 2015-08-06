require 'para'
require 'dash'
require 'quotes'
require 'dbg'
dofile('choice.lua');

game.forcedsc = false;
game._action = nil;
game.actions = {}

pl._connections = 0;
pl._boldness = 0;
pl._caution = 0

rndstr = function(strings)
	return strings[rnd(stead.table.maxn(strings))];
end

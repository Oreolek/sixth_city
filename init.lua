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
playerdesc = stat {
  nam = function()
    pn(txtc(txtb('Персонаж')));
    pn('Связи: '..pl._connections);
    pn('Дерзость: ' .. pl._boldness);
    pn('Осторожность: ' .. pl._caution);
    -- if (game._action ~= nil) then
    --  pn("Локация: "..game._action);
    -- end
  end,
}
take('playerdesc');

connected = function(i)
  pl._connections = pl._connections + i;
  pn ("Параметр Связи увеличился на "..i..".");
end;

bold = function(i)
  pl._boldness = pl._boldness + i;
  pn ("Параметр Дерзость увеличился на "..i..".");
end;

cautious = function(i)
  pl._caution = pl._caution + i;
  pn ("Параметр Осторожность увеличился на "..i..".");
end;

rndstr = function(strings)
	return strings[rnd(stead.table.maxn(strings))];
end

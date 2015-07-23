require 'para'
require 'dash'
require 'quotes'

game.forcedsc = false;
game._action = nil;
game.actions = {}

rndstr = function(strings)
	return strings[rnd(stead.table.maxn(strings))];
end

function isDisabled(v)
  if (type(v) ~= 'table') then return false end;
	if (type(v._disabled) == 'function') then return v._disabled(); end;
  if v.filter ~= nil then
    local condition = assert(loadstring("return not ("..v.filter..");"));
    return condition();
  end;  
  return v._disabled;
end

function action(o)
  o.nam = o.nam.."^";
  o.dsc = "{"..o.nam.."}";
  o.act = function(s)
    if o.new_filter == nil then
      p(s._dsc);
    end
    if (s.click ~= nil and type(s.click) == 'function') then
      s.click(s);
    end
    here():look(); -- нам нужно перерисовать комнату
    if o.new_filter ~= nil then
  	  game._action = s.new_filter
      -- БАГ: надо не просто вернуться назад, а ещё и вывести текущее описание сцены, а оно не меняется
      --if (deref(o.new_filter) ~= nil) then
      --  deref(o.new_filter).act();
      --end
      p(s._dsc);
    end
  end;
  if o._disabled == nil and o.filter == nil then
    o._disabled = function()
      if (game._action == nil) then
        return false;
      end;
      return true;
    end;
  end
  local retval = obj(o);
  table.insert(game.actions, retval);
  return retval;
end

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

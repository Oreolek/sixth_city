-- Здесь я переделываю диалоги INSTEAD на другую структуру
-- мне нужно, чтобы фразы не автоматически скрывались, а постоянно оставались и скрывались при просмотре комнаты, а не после кликов

function isDisabled(v)
  if (type(v) ~= 'table') then return false end;
	if (type(v._disabled) == 'function') then return v._disabled(); end;
  if v.filter ~= nil then
    local condition = assert(loadstring("return not ("..v.filter..");"));
    return condition();
  end;
  return v._disabled;
end

choice_look = function(self)
	local i,v,ph
	for i,ph in opairs(self.obj) do
		ph = ref(ph);
		if isPhrase(ph) and not isDisabled(ph) then
			v = par('^', v, ph:look());
		end
	end
	return v;
end

function choice(v) --constructor
	if v.look == nil then
		v.look = choice_look;
	end
	v = dlg(v);
	return v;
end

option_action = function(self)
	local ph = self;
	local r, ret;

	if isDisabled(ph) then
		return nil, false
	end

	local last = stead.call(ph, 'ans');
  
	if type(ph.do_act) == 'string' then
		local f = stead.eval(ph.do_act);
		if f ~= nil then
			ret = f();
		else
			error ("Error while eval phrase action.");
		end
	elseif type(ph.do_act) == 'function' then
		ret = ph.do_act(self);
	end

	if ret == nil then ret = stead.pget(); end

	if last == true or ret == true then
		return true;
	end

	local wh = stead.here();

	while isDialog(wh) and not stead.dialog_rescan(wh) and stead.from(wh) ~= wh do
		wh = stead.from(wh)
	end

	if wh ~= stead.here() then
		ret = stead.par(stead.space_delim, ret, stead.back(wh));
	end
	
	ret = stead.par(stead.scene_delim, last, ret);
	
	return ret
end


function option(filter, ask, answ, actfunc)
	local p = phr (ask, answ, actfunc);
  p.do_act = actfunc;
  p.filter = filter;
  if filter ~= nil then
    local condition = assert(loadstring("return not ("..filter..");"));
    p._disabled = condition();
  else
    p._disabled = false;
  end
  p.act = option_action;
	return p;
end

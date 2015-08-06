-- $Name: Шестой город$
-- $Name(en): Sixth city$
-- Игра требует Lua 5.1+
instead_version "1.9.1"
dofile('choice.lua');
dofile("init.lua");

function load_mo_file(mo_file)
  --------------------------------
  -- open file and read data
  --------------------------------
  local fd,err=io.open(mo_file,"rb")
  if not fd then return nil,err end
  local mo_data=fd:read("*all")
  fd:close()

  --------------------------------
  -- precache some functions
  --------------------------------
  local byte=string.byte
  local sub=string.sub

  --------------------------------
  -- check format
  --------------------------------
  local peek_long --localize
  local magic=sub(mo_data,1,4)
  -- intel magic 0xde120495
  if magic=="\222\018\004\149" then
    peek_long=function(offs)
      local a,b,c,d=byte(mo_data,offs+1,offs+4)
      return ((d*256+c)*256+b)*256+a
    end
  -- motorola magic = 0x950412de
  elseif magic=="\149\004\018\222" then
    peek_long=function(offs)
      local a,b,c,d=byte(mo_data,offs+1,offs+4)
      return ((a*256+b)*256+c)*256+d
    end
  else
    return nil,"no valid mo-file"
  end

  --------------------------------
  -- version
  --------------------------------
  local V=peek_long(4)
  if V~=0 then
    return nul,"unsupported version"
  end

  ------------------------------
  -- get number of offsets of table
  ------------------------------
  local N,O,T=peek_long(8),peek_long(12),peek_long(16)
  ------------------------------
  -- traverse and get strings
  ------------------------------
  local hash={}
  for nstr=1,N do
    local ol,oo=peek_long(O),peek_long(O+4) O=O+8
    local tl,to=peek_long(T),peek_long(T+4) T=T+8
    hash[sub(mo_data,oo+1,oo+ol)]=sub(mo_data,to+1,to+tl)
  end
  return function(text)
    return hash[text] or text
  end
end

if not LANG then
	LANG = "en"
end

if LANG == 'en' then
  __ = load_mo_file('en.mo');
else
  __ = function(text)
    return text;
  end;
end

main = choice{
  nam = __('Шестой город'),
  dsc = __([[Облака никогда не рассеиваются, они могут только становиться светлее. Вы стоите на круглой площади перед мрачным памятником, откуда начинается извилистый лабиринт улиц Шестого города. Невысокие дома окружают вас со всех сторон, скрываясь в тумане.^^
  Потёртый буклет, который вы нашли в мусорном баке возле гостиницы, предлагает несколько интересных занятий для "гостей города Н."]]),
  obj = {},
};

dofile("game.lua");

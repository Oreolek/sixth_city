monument = action {
  nam = 'Осмотреть памятник',
  act = function()
    game._action = "tower";
    pn ("Чёрный памятник без таблички изображает высокого мужчину в старомодном плаще, который держит в руках раскрытый зонт. Мужчина застыл, направив взгляд на небо.");
    pn ('На основании памятника нацарапано: "Господин Гронц видел тебя"');
    connected(1);
    monument._disabled = true;
    game._action = nil;
  end,
}

museum = action {
  nam = 'Посетить музей Сгоревших Свечей',
}

circus = action {
  nam = 'Направиться в Красный Цирк',
}

clock = action {
  nam = 'Найти Глиняную Башню',
  act = function()
    game._action = "clock";
    return [[ Вы подходите к старинной башне, целиком вылепленной из красной глины. На верхушке башни находится циферблат часов, застрявших на шести часах двадцати минут.]]
  end,
}

police = action {
  nam = 'Искать Отделение Криминального Давления',
  act = function()
    game._action = "police";
    return [[Буклет-путеводитель описывает Отделение Криминального Давления как "департамент наивысшей безопасности по защите от наихудшей преступности.^^
    Издалека вам кажется, что здание О.К.Д. украшено живыми прыгучими мышами, но вблизи вы видите, что мышей всего лишь колышет лёгкий ветер. В здание часто заходят люди в тёмно-синей форме, но, насколько вы можете заметить, через тяжёлые двери выходят немногие. Вы не замечаете ничего странного, входя внутрь, только половицы слишком громко скрипят.]];
  end,
}

thief = action {
  nam = 'Вы засовываете руку в карман и находите там чужую',
  _disabled = function() if (game._action == "police" and pl._boldness < 5 and not have('cent')) then return false; end; return true; end,
  act = function()
    game._action = "thief";
    return [[Вы засовываете руку в карман и находите там чужую. Вы разворачиваетесь и видите грязного мальчика, который пытается спрятать лицо под дырявой кепкой.]];
  end,
}

thief_bold = action {
  nam = 'Побить вора',
  _disabled = function() if (game._action == "thief") then return false; end; return true; end,
  act = function()
    game._action = "police";
    connected(1);
    bold(1);
    take('cent');
    return [[Вы перетряхиваете мальчугана на всё, что у него есть. Он отдаёт вам единственную монетку и теряется в тумане.]];
  end,
}

thief_follow = action {
  nam = 'Отпустить и проследить за ним',
  _disabled = function() if (game._action == "thief") then return false; end; return true; end,
  act = function()
    game._action = "police";
    connected(1);
    cautious(1);
    take('cent');
    return [[Вы отпускаете мальчугана и осторожно следуете за ним. Он отбегает в сторону, оглядывается, и, не заметив вас в тумане, идёт по переулкам к старому фонтану на Площади Жути.^^
    По пустой улице проносится слабый звон, и мальчик быстро исчезает в одном из домов. Вы подходите к пересохшему фонтану и видите одинокую монетку, которая блестит на дне. Вы поднимаете монетку и осматриваете её. Выглядит интересно. ]];
  end,
}

cent = obj {
  nam = 'цент',
  inv = 'Потемневшая монета в одну местную копейку. На реверсе монеты иголкой нацарапана спираль.'
}

eradication_lvl1 = action {
  nam = 'На вас бросается женщина...',
  _disabled = function() if (game._action == "police" and pl._boldness < 5 and not have('clay_leg')) then return false; end; return true; end,
  act = function()
    game._action = "eradication_lvl1_1";
    return [[ На вас бросается женщина с зарёванным лицом. Мужчина в форме, с которым она до этого разговаривала, облегчённо вздыхает и уходит по своим делам. ^
    -- Пожалуйста! Может, хоть вы мне поможете? Я не могу попасть домой и у меня нет с собой денег, чтобы заплатить Охотникам. Я не могу пробиться через эти грибы!]];
  end,
}

eradication_lvl1_1 = action {
  nam = 'Следовать к её дому',
  _disabled = function() if (game._action == "eradication_lvl1_1") then return false; end; return true; end,
  act = function()
    game._action = "eradication_lvl1";
    return [[ Она живёт к западу от Глиняной Башни, в квартале Улыбающихся Гончаров. Вы медленно пробираетесь по петляющим улочкам и, наконец, выходите к старому домику, перед которым раскинулись высокие коричневые заросли грибов.Она даёт вам белый платок и показывает, как его завязать на лицо. ^^ 
    -- Вы видите? Я не могу пройти к дому, не наглотавшись спор. Я читала, что споры этих грибов превращают людей в.. в глину!]];
  end,
}

-- тут можно придумать дополнительные варианты в зависимости от инвентаря
eradication_lvl1_cautious = action {
  nam = 'Осторожно',
  _disabled = function() if (game._action == "eradication_lvl1") then return false; end; return true; end,
  act = function()
    cautious(1);
    take('clay_leg');
    game._action = "police";
    return [[]];
  end,
}

eradication_lvl1_bold = action {
  nam = 'Дерзко',
  _disabled = function() if (game._action == "eradication_lvl1") then return false; end; return true; end,
  act = function()
    bold(1);
    take('clay_leg');
    game._action = "police";
    return [[]];
  end,
}

clay_leg = obj {
  nam = 'пластилиновая нога',
  inv = 'Нога Пластилинового Творения.'
}

tattoo = action {
  _disabled = function() if (pl._connections > 5) then return false end; return true; end,
  nam = 'Посетить тату-салон Чернильного Ткача'
}

turn_back = action {
  nam = '-- Вернуться на площадь --',
  _disabled = function() if (game._action ~= nil) then return false; end; return true; end,
  act = function()
    game._action = nil;
    walk('main');
  end,
}

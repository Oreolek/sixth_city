playerdesc = stat {
  nam = function()
    pn(txtc(txtb(__('Персонаж'))));
    pn(__('Связи')..': '..pl._connections);
    pn(__('Дерзость')..': ' .. pl._boldness);
    pn(__('Осторожность')..': ' .. pl._caution);
  end,
}
take('playerdesc');

connected = function(i)
  pl._connections = pl._connections + i;
  pn (__("Параметр Связи увеличился на ")..i..".");
end;

bold = function(i)
  pl._boldness = pl._boldness + i;
  pn (__("Параметр Дерзость увеличился на ")..i..".");
end;

cautious = function(i)
  pl._caution = pl._caution + i;
  pn (__("Параметр Осторожность увеличился на ")..i..".");
end;

turn_back = option(nil, '-- '..__('Вернуться на площадь')..' --', '', 'walk("main")');

put(option(
  'pl._seen_monument ~= true',
  __('Осмотреть памятник'),
  __([[Чёрный памятник без таблички изображает высокого мужчину в старомодном плаще, который держит в руках раскрытый зонт. Мужчина застыл, направив взгляд на небо.^^
  На основании памятника нацарапано: "Господин Гронц видел тебя"]]),
  function() connected(1); pl._seen_monument = true; end
));
put(option(nil, __('Посетить музей Сгоревших Свечей'), nil, 'walk("museum")'));
put(option(nil, __('Найти Глиняную Башню'), nil, 'walk("clock")'));
put(option(nil, __('Искать Отделение Криминального Давления'), nil, 'walk("police")'));

clock = choice {
  nam = __('Глиняная Башня'),
  enter = __([[Вы подходите к старинной башне, целиком вылепленной из красной глины.]]),
  dsc = __([[На верхушке башни находится циферблат часов, застрявших на шести часах двадцати минут.]]),
  obj = {turn_back}
}

museum = choice {
  nam = __('Музей Сгоревших Свечей'),
  dsc = __('Музей Сгоревших Свечей -- это здание середины девятнадцатого века, изрядно потрёпанное временем.'),
  enter = __('На входе вам дают кусочек воска, на котором написан номер билета.'),
  exit = __('Вы кидаете билет в камин, горящий на выходе.'),
  obj = {turn_back}
}

police = choice {
  nam = __('Отделение Криминального Давления'),
  dsc = __([[Буклет-путеводитель описывает Отделение Криминального Давления как "департамент наивысшей безопасности по защите от наихудшей преступности."]]),
  enter = __([[Издалека вам кажется, что здание О.К.Д. украшено живыми прыгучими мышами, но вблизи вы видите, что мышей всего лишь колышет лёгкий ветер. В здание часто заходят люди в тёмно-синей форме, но, насколько вы можете заметить, через тяжёлые двери выходят немногие. Вы не замечаете ничего странного, входя внутрь, только половицы слишком громко скрипят.]]),
  obj = {}
}
thief_option = option('pl._boldness < 5 and not have("cent")', __('Вы засовываете руку в карман и находите там чужую'), nil, 'walk("thief")');
put ('thief_option', 'police');
put(option('pl._boldness < 5 and not have("clay_leg")', __('На вас бросается женщина...'), nil, 'walk("eradication")'), 'police');
put (turn_back, 'police');

thief = choice {
  nam = __('Вы засовываете руку в карман и находите там чужую'),
  dsc = __([[Вы засовываете руку в карман и находите там чужую. Вы разворачиваетесь и видите грязного мальчика, который пытается спрятать лицо под дырявой кепкой.]]),
  obj = {}
}
put(option(nil, __('Побить вора'), __('Вы перетряхиваете мальчугана на всё, что у него есть. Он отдаёт вам единственную монетку и теряется в тумане.'),function()
    connected(1);
    bold(1);
    take('cent');
    walk('police');
  end
), 'thief');

put(option(nil, __('Отпустить и проследить за ним'), __([[Вы отпускаете мальчугана и осторожно следуете за ним. Он отбегает в сторону, оглядывается, и, не заметив вас в тумане, идёт по переулкам к старому фонтану на Площади Жути.^^
    По пустой улице проносится слабый звон, и мальчик быстро исчезает в одном из домов. Вы подходите к пересохшему фонтану и видите одинокую монетку, которая блестит на дне. Вы поднимаете монетку и осматриваете её. Выглядит интересно. ]]),function()
    cautious(1);
    connected(1);
    take('cent');
    walk('police');
  end
), 'thief');

cent = obj {
  nam = __('цент'),
  inv = __('Потемневшая монета в одну местную копейку. На реверсе монеты иголкой нацарапана спираль.')
}

eradication = choice {
  nam = __('На вас бросается женщина...'),
  dsc = __([[На вас бросается женщина с зарёванным лицом. Мужчина в форме, с которым она до этого разговаривала, облегчённо вздыхает и уходит по своим делам. ^
    -- Пожалуйста! Может, хоть вы мне поможете? Я не могу попасть домой и у меня нет с собой денег, чтобы заплатить Охотникам. Я не могу пробиться через эти грибы!]]),
  obj = {
    option(nil, __('Следовать к её дому'), nil, 'walk("eradication_cont")'),
  }
}
eradication_cont = choice {
  nam = __('Дом в квартале Улыбающихся Гончаров'),
  enter = __([[Она живёт к западу от Глиняной Башни, в квартале Улыбающихся Гончаров. Вы медленно пробираетесь по петляющим улочкам и, наконец, выходите к старому домику, перед которым раскинулись высокие коричневые заросли грибов.Она даёт вам белый платок и показывает, как его завязать на лицо.]]),
  dsc = __([[-- Вы видите? Я не могу пройти к дому, не наглотавшись спор. Я читала, что споры этих грибов превращают людей в.. в глину!]]),
  obj = {},
}

-- тут можно придумать дополнительные варианты в зависимости от инвентаря
put(option(nil, __('Медленно протоптать дорожку'), __([[Осторожно контролируя вес, вы протаптываете дорожку через заросли грибов. Придётся ходить только в масках, но теперь здесь есть шансы жить.^^
    -- Спасибо! Вот вам за труды. -- Женщина протягивает изогнутый кусок пластилина. -- Говорят, за ноги Пластилиновых Творений дорого платят в музее Сгоревших Свечей. ]]),function()
    cautious(1);
    take('clay_leg');
    walk('police');
  end),
'eradication_cont');

put(option(nil, __('Быстро перепрыгнуть через заросли'), __([[Разбежавшись, вы перепрыгиваете заросли и приземляетесь на пороге дома. Похоже, хозяйке придётся упражняться в прыжках, но хотя бы у неё появились шансы здесь жить.^^
    -- Спасибо! Вот вам за труды. -- Женщина протягивает изогнутый кусок пластилина. -- Говорят, за ноги Пластилиновых Творений дорого платят в музее Сгоревших Свечей. ]]),function()
    bold(1);
    take('clay_leg');
    walk('police');
  end),
'eradication_cont');

clay_leg = obj {
  nam = __('пластилиновая нога'),
  inv = __('Нога Пластилинового Творения.')
}

put(option('pl._connections > 0', __('Сесть на поезд домой'), nil, "walk('endgame')"));

endgame = room {
  nam = __('Конец игры'),
  dsc = __([[Ваше время в этом мрачном городе закончено, и вы уезжаете на старом поезде, всё ещё слишком чужой для того, чтобы остаться.^^]])..txtc(__('КОНЕЦ')),
}

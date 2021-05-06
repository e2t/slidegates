unit Localization;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

const
  Eng = 0;
  Rus = 1;

type
  TLang = Eng..Rus;

var
  L10n: array [0..100, TLang] of string;

implementation

initialization

  L10n[0, Eng] := 'Pressure head %.3G m H2O';
  L10n[0, Rus] := 'Гидростатический напор %.3G м вод. ст.';

  L10n[1, Eng] := 'Weight of stainless steel %.1F kg';
  L10n[1, Rus] := 'Масса нерж. стали %.1F кг';

  L10n[2, Eng] := 'S';
  L10n[2, Rus] := 'П';

  L10n[3, Eng] := 'D';
  L10n[3, Rus] := 'Г';

  L10n[4, Eng] := 'СOR';
  L10n[4, Rus] := 'КР';

  L10n[5, Eng] := 'WOR';
  L10n[5, Rus] := 'НР';

  L10n[6, Eng] := 'E';
  L10n[6, Rus] := 'Э';

  L10n[7, Eng] := 'M';
  L10n[7, Rus] := 'Р';

  L10n[8, Eng] := 'SG';
  L10n[8, Rus] := 'ЗЩ';

  L10n[9, Eng] := 'Right-hand screw';
  L10n[9, Rus] := 'Винт с правой резьбой';

  L10n[10, Eng] := 'Left-hand screw';
  L10n[10, Rus] := 'Винт с левой резьбой';

  L10n[11, Eng] := '%S %S stainless steel (calibrated rod %.3Gh9) — %.3G m';
  L10n[11, Rus] := '%S %S нерж. (круг калибр. %.3Gh9) — %.3G м';

  L10n[12, Eng] := 'Bronze nut %S (◻%.0Fx%.0F, L=%.0F)';
  L10n[12, Rus] := 'Гайка бронзовая %S (◻%.0Fx%.0F, L=%.0F)';

  L10n[13, Eng] := 'Self-made nut';
  L10n[13, Rus] := 'Гайка собственного изготовления';

  L10n[14, Eng] := 'Bronze strip %S L=%G mm';
  L10n[14, Rus] := 'Полоса бронзовая %S L=%G мм';

  L10n[15, Eng] := 'Screw %S, factor of safity %.1F';
  L10n[15, Rus] := 'Винт %S, запас прочности %.1F';

  L10n[16, Eng] := 'Minimal inertia moment %.0F mm4';
  L10n[16, Rus] := 'Минимальный момент инерции %.0F мм4';

  L10n[17, Eng] := 'The slenderness ratio of the spindle %.0F';
  L10n[17, Rus] := 'Коэффициент гибкости стержня %.0F';

  L10n[18, Eng] := 'Axial force in screw %.0F N';
  L10n[18, Rus] := 'Осевая сила на винте %.0F Н';

  L10n[19, Eng] := 'Torque in screw %.1F Nm';
  L10n[19, Rus] := 'Крутящий момент на винте %.1F Нм';

  L10n[20, Eng] := 'It is not possible to select a standard screw.';
  L10n[20, Rus] := 'Невозможно подобрать стандартный винт.';

  L10n[21, Eng] := 'Frame with crossbar for screw';
  L10n[21, Rus] := 'Рама с перекладиной для винта';

  L10n[22, Eng] := 'Frame without crossbar for screw';
  L10n[22, Rus] := 'Рама без перекладины для винта';

  L10n[23, Eng] := 'Wedges - %D pairs';
  L10n[23, Rus] := 'Клинья - %D пары';

  L10n[24, Eng] := 'Minimum diameter of the nut axis %.1F mm';
  L10n[24, Rus] := 'Минимальный диаметр осей гайки %.1F мм';

  L10n[25, Eng] := 'Hydrostatic load - %.0F N';
  L10n[25, Rus] := 'Гидростатическая нагрузка - %.0F Н';

  L10n[26, Eng] := 'Minimum inner diameter %.1F mm.';
  L10n[26, Rus] := 'Минимальный внутренний диаметр %.1F мм.';

  L10n[27, Eng] :=
    'It is impossible to select a standard gearbox. Minimum torque %.1F Nm.';
  L10n[27, Rus] :=
    'Невозможно подобрать стандартный редуктор. ' +
    'Минимальный крутящий момент %.1F Нм';

  L10n[28, Eng] :=
    'It is impossible to select a standard actuator. ' +
    'Minimum torque %.1F Nm. Minimum speed %.1F rpm.';
  L10n[28, Rus] :=
    'Невозможно подобрать стандартный привод. ' +
    'Минимальный крутящий момент %.1F Нм. ' +
    'Минимальная скорость вращения %.1F об/мин.';

  L10n[29, Eng] := 'Actuator AUMA %S%S';
  L10n[29, Rus] := 'Мотор-редуктор AUMA %S%S';

  L10n[30, Eng] := 'Actuator %S';
  L10n[30, Rus] := 'Мотор-редуктор %S';

  L10n[31, Eng] := 'Output speed %.1F rpm';
  L10n[31, Rus] := 'Скорость вращения %.1F об/мин';

  L10n[32, Eng] := 'Electric power %.2F kW';
  L10n[32, Rus] := 'Мощность %.2F кВт';

  L10n[33, Eng] := 'Torque %.0F-%.0F Nm';
  L10n[33, Rus] := 'Крутящий момент %.0F-%.0F Нм';

  L10n[34, Eng] := 'Flange type %S';
  L10n[34, Rus] := 'Присоединительный фланец %S';

  L10n[35, Eng] := 'Valve attachment %S';
  L10n[35, Rus] := 'Присоединительная втулка %S';

  L10n[36, Eng] := 'Type of duty %S';
  L10n[36, Rus] := 'Кратковременный режим работы %S';

  L10n[37, Eng] := 'Right-hand closing (clockwise)';
  L10n[37, Rus] :=
    'Правостороннее закрытие (по часовой стрелке)';

  L10n[38, Eng] := 'Torque %.0F Nm for opening, %.0F Nm for closing';
  L10n[38, Rus] :=
    'Крутящий момент на открытие %.0F Нм, на закрытие %.0F Нм';

  L10n[39, Eng] := 'Full opening through %.1F min (%.1F sec) and %.1F rev';
  L10n[39, Rus] :=
    'Полное открытие через %.1F мин (%.1F сек) и %.1F оборотов';

  L10n[40, Eng] := 'Temperature range %.0F °C to %.0F °C';
  L10n[40, Rus] := 'Температурный диапазон %.0F °C до %.0F °C';

  L10n[41, Eng] := 'Voltage 380 V / 50 Hz / 3ph';
  L10n[41, Rus] := 'Напряжение питания 380 В / 50 Гц / 3ф';

  L10n[42, Eng] := 'General industrial design';
  L10n[42, Rus] := 'Общепромышленное исполнение';

  L10n[43, Eng] := 'Enclosure protection — IP 68';
  L10n[43, Rus] := 'Степень защиты оболочки — IP 68';

  L10n[44, Eng] := 'Corrosion protection — KS';
  L10n[44, Rus] := 'Антикоррозионная защита оболочки — KS';

  L10n[45, Eng] := 'Limit switches — single';
  L10n[45, Rus] := 'Концевые выключатели — одиночные';

  L10n[46, Eng] := 'Intermediate position switches — no';
  L10n[46, Rus] := 'Промежуточные выключатели — нет';

  L10n[47, Eng] := 'Torque switches — single';
  L10n[47, Rus] := 'Моментные выключатели — одиночные';

  L10n[48, Eng] := 'Blinker transmitter — yes';
  L10n[48, Rus] := 'Индикатор работы привода — да';

  L10n[49, Eng] := 'Mechanical position indication — no';
  L10n[49, Rus] :=
    'Механический указатель положения — нет';

  L10n[50, Eng] := 'Stem protection tube — no';
  L10n[50, Rus] :=
    'Защитная труба для выдвижного штока — нет';

  L10n[51, Eng] := 'Electronic position transmitter — no';
  L10n[51, Rus] :=
    'Дистанционный указатель положения — нет';

  L10n[52, Eng] := 'Cable glands — yes';
  L10n[52, Rus] := 'Комплект кабельных вводов — да';

  L10n[53, Eng] := 'Cable type — unarmoured';
  L10n[53, Rus] := 'Тип кабеля — небронированный';

  L10n[54, Eng] := 'Outside cable diameter — standard';
  L10n[54, Rus] := 'Наружный диаметр кабеля — стандарт';

  L10n[55, Eng] := 'Actuator controls %S';
  L10n[55, Rus] := 'Блок управления %S';

  L10n[56, Eng] := 'Spur gearbox %S %S';
  L10n[56, Rus] := 'Цилиндрический редуктор %S %S';

  L10n[57, Eng] := 'Ratio %.1G';
  L10n[57, Rus] := 'Передаточное отношение %.1G';

  L10n[58, Eng] := 'Right angle gearbox %S %S';
  L10n[58, Rus] := 'Угловой редуктор %S %S';

  L10n[59, Eng] := 'Max torque %.0F Nm';
  L10n[59, Rus] := 'Максимальный крутящий момент %.0F Нм';

  L10n[60, Eng] := 'Self-made two-armed handle';
  L10n[60, Rus] := 'Двуплечая рукоятка собственного изготовления';

  L10n[61, Eng] := 'Handwheel %S';
  L10n[61, Rus] := 'Штурвал %S';

  L10n[62, Eng] := 'Incorrect value.';
  L10n[62, Rus] := 'Неправильное значение.';

  L10n[63, Eng] := 'Sheet %G mm stainless steel — %.1F kg';
  L10n[63, Rus] := 'Лист %G мм нерж. — %.1F кг';

  L10n[64, Eng] := 'Calculated torque %.0F Nm';
  L10n[64, Rus] := 'Расчетный крутящий момент %.0F Нм';

  L10n[65, Eng] := 'Leakage %.1F l/min';
  L10n[65, Rus] := 'Утечки %.1F л/мин';

  L10n[66, Eng] := 'Bronze nut %S (Ø%.0F, L=%.0F)';
  L10n[66, Rus] := 'Гайка бронзовая %S (Ø%.0F, L=%.0F)';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

  //L10n[, Eng] := '';
  //L10n[, Rus] := '';

end.
(*
# затвор щитовой - slidegate
msgid "SG{l_type}{l_drive} {frame_w}x{frame_h}({gate_h})"
msgstr "ЗЩ{l_type}{l_drive} {frame_w}x{frame_h}({gate_h})"


msgid " * frame {mass} kg, thickness {thickness} mm"
msgstr " * рама {mass} кг, толщина {thickness} мм"

msgid " * gate {mass} kg, thickness {thickness} mm"
msgstr " * щит {mass} кг, толщина {thickness} мм"

msgid " * screw {mass} kg"
msgstr " * винт {mass} кг"

msgid " * rack {mass} kg{number}"
msgstr " * колонка {mass} кг{number}"



msgid "Sheet {thickness:g} mm stainless steel — {mass:.1f} kg"
msgstr "Лист {thickness:g} мм нерж. — {mass:.1f} кг"






msgid "weight {mass} kg"
msgstr "масса {mass} кг"





msgid "Torque in every screw {torque} Nm"
msgstr "Крутящий момент на каждом винте {torque} Нм"



msgid "Free torque in every screw {torque} Nm"
msgstr "Свободный крутящий момент на каждом винте {torque} Нм"



msgid "mounting flange {flange} for the actuator"
msgstr "с монтажным фланцем {flange} для привода"




msgid "Axial force in every screw {force} N"
msgstr "Осевая сила на каждом винте {force} Н"


msgid "Wedges {wedge} ({material}) - {pairs} pairs{all}"
msgstr "Клинья {wedge} ({material}) - {pairs} пары{all}"

msgid " ({bolt} for the {number} pairs)"
msgstr " ({bolt} для {number} пар)"


msgid "The frame {depth} x {shelf} mm, s = {thick} mm"
msgstr "Рама {depth} x {shelf} мм, s = {thick} мм"



msgid "The gate {width} x {depth} x {shelf} mm, s = {thick} mm"
msgstr "Щит {width} x {depth} x {shelf} мм, s = {thick} мм"

msgid "Edges of the gate {height}, s = {thick} mm: horizontal {horiz}{vert}"
msgstr "Ребра щита {height}, s = {thick} мм: горизонтальных {horiz}{vert}"

msgid ", vertical {vert}"
msgstr ", вертикальных {vert}"

msgid "Profile of the cover {depth} x {shelf} mm, s = {thick} mm"
msgstr "Профиль кожуха {depth} x {shelf} мм, s = {thick} мм"

msgid "left-hand closing (counter-clockwise)"
msgstr "левостороннее закрытие (против часовой стрелки)"


msgid "polyamide"
msgstr "полиамид"

msgid "bronze"
msgstr "бронза"

msgid "the reverse marking open/close on the handwheel"
msgstr "обратная маркировка откр./закр. на штурвале"



msgid "no"
msgstr "нет"

*)

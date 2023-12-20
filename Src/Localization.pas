unit Localization;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

type
  TLang = (Eng, Ukr, Rus);

var
  L10nOut: array [0..95, TLang] of string;
  L10nGui: array [0..55, TLang] of string;

implementation

initialization
  L10nOut[0, Eng] := 'Pressure head %.3G m H2O';
  L10nOut[0, Ukr] := 'Гідростатичний тиск %.3G м вод. ст.';
  L10nOut[0, Rus] := 'Гидростатический напор %.3G м вод. ст.';

  L10nOut[1, Eng] := 'Weight of stainless steel %.0F kg';
  L10nOut[1, Ukr] := 'Вага нерж. сталі %.0F кг';
  L10nOut[1, Rus] := 'Вес нерж. стали %.0F кг';

  L10nOut[2, Eng] := 'S';
  L10nOut[2, Ukr] := 'П';
  L10nOut[2, Rus] := 'П';

  L10nOut[3, Eng] := 'D';
  L10nOut[3, Ukr] := 'Г';
  L10nOut[3, Rus] := 'Г';

  L10nOut[4, Eng] := 'СOR';
  L10nOut[4, Ukr] := 'КР';
  L10nOut[4, Rus] := 'КР';

  L10nOut[5, Eng] := 'WOR';
  L10nOut[5, Ukr] := 'НР';
  L10nOut[5, Rus] := 'НР';

  L10nOut[6, Eng] := 'E';
  L10nOut[6, Ukr] := 'Е';
  L10nOut[6, Rus] := 'Э';

  L10nOut[7, Eng] := 'M';
  L10nOut[7, Ukr] := 'Р';
  L10nOut[7, Rus] := 'Р';

  L10nOut[8, Eng] := 'SG';
  L10nOut[8, Ukr] := 'ЗЩ';
  L10nOut[8, Rus] := 'ЗЩ';

  L10nOut[9, Eng] := 'Right-hand screw';
  L10nOut[9, Ukr] := 'Гвинт з правою різьбою';
  L10nOut[9, Rus] := 'Винт с правой резьбой';

  L10nOut[10, Eng] := 'Left-hand screw';
  L10nOut[10, Ukr] := 'Гвинт з лівою різьбою';
  L10nOut[10, Rus] := 'Винт с левой резьбой';

  L10nOut[11, Eng] := '%S %S stainless steel (calibrated rod %.3Gh9) — %.3G m';
  L10nOut[11, Ukr] := '%S %S нерж. (круг калібр. %.3Gh9) — %.3G м';
  L10nOut[11, Rus] := '%S %S нерж. (круг калибр. %.3Gh9) — %.3G м';

  L10nOut[12, Eng] := 'Bronze square nut %S ◻%.0Fx%.0F, L=%.0F';
  L10nOut[12, Ukr] := 'Гайка бронзова квадратна %S ◻%.0Fx%.0F, L=%.0F';
  L10nOut[12, Rus] := 'Гайка бронзовая квадратная %S ◻%.0Fx%.0F, L=%.0F';

  L10nOut[13, Eng] := 'Self-made nut';
  L10nOut[13, Ukr] := 'Гайка власного виготовлення';
  L10nOut[13, Rus] := 'Гайка собственного изготовления';

  L10nOut[14, Eng] := 'ЗЩНК.01-00.001 Pad on the wedge — %G pcs.';
  L10nOut[14, Ukr] := 'ЗЩНК.01-00.001 Накладка клина — %G шт.';
  L10nOut[14, Rus] := 'ЗЩНК.01-00.001 Накладка клина — %G шт.';

  L10nOut[15, Eng] := 'Screw %S (inner %S), factor of safity %S';
  L10nOut[15, Ukr] := 'Гвинт %S (внутр. %S), запас міцності %S';
  L10nOut[15, Rus] := 'Винт %S (внутр. %S), запас прочности %S';

  L10nOut[16, Eng] := 'Minimal inertia moment %.0F mm^4';
  L10nOut[16, Ukr] := 'Мінімальний момент інерції %.0F мм^4';
  L10nOut[16, Rus] := 'Минимальный момент инерции %.0F мм^4';

  L10nOut[17, Eng] := 'Slenderness ratio of the spindle %.0F (should be less than 250)';
  L10nOut[17, Ukr] := 'Коефіцієнт гнучкості стрижня %.0F (має бути менше 250)';
  L10nOut[17, Rus] := 'Коэффициент гибкости стержня %.0F (должен быть меньше 250)';

  L10nOut[18, Eng] := 'Axial force in screw %.0F…%.0F N';
  L10nOut[18, Ukr] := 'Осьова сила на гвинті %.0F…%.0F Н';
  L10nOut[18, Rus] := 'Осевое усилие на винте %.0F…%.0F Н';

  L10nOut[19, Eng] := 'Torque in screw %.0F…%.0F Nm';
  L10nOut[19, Ukr] := 'Обертальний момент на гвинті %.0F…%.0F Нм';
  L10nOut[19, Rus] := 'Крутящий момент на винте %.0F…%.0F Нм';

  L10nOut[20, Eng] := 'It is not possible to select a standard screw.';
  L10nOut[20, Ukr] := 'Неможливо підібрати стандартний гвинт.';
  L10nOut[20, Rus] := 'Невозможно подобрать стандартный винт.';

  L10nOut[21, Eng] := 'Frame with crossbar for screw';
  L10nOut[21, Ukr] := 'Рама з поперечиною для гвинта';
  L10nOut[21, Rus] := 'Рама с перекладиной для винта';

  L10nOut[22, Eng] := 'Frame without crossbar for screw';
  L10nOut[22, Ukr] := 'Рама без поперечини для гвинта';
  L10nOut[22, Rus] := 'Рама без перекладины для винта';

  L10nOut[23, Eng] := 'Wedges — %D pairs';
  L10nOut[23, Ukr] := 'Клини — %D пари';
  L10nOut[23, Rus] := 'Клинья — %D пары';

  L10nOut[24, Eng] := 'Minimum diameter of the screw pins %.1F mm';
  L10nOut[24, Ukr] := 'Мінімальний діаметр штифтів гвинта %.1F мм';
  L10nOut[24, Rus] := 'Минимальный диаметр штифтов винта %.1F мм';

  L10nOut[25, Eng] := 'Hydrostatic load %.0F N';
  L10nOut[25, Ukr] := 'Гідростатичне навантаження %.0F Н';
  L10nOut[25, Rus] := 'Гидростатическая нагрузка %.0F Н';

  L10nOut[26, Eng] := 'Minimum inner diameter %.1F mm.';
  L10nOut[26, Ukr] := 'Мінімальний внутрішній діаметр %.1F мм.';
  L10nOut[26, Rus] := 'Минимальный внутренний диаметр %.1F мм.';

  L10nOut[27, Eng] :=
    'It is impossible to select a standard gearbox. Minimum torque %.1F Nm.' +
    LineEnding +
    'If the torque is within the permissible limits, try changing the gearbox manufacturer.';
  L10nOut[27, Ukr] := 'Неможливо підібрати стандартний редуктор. Мінімальний обертальний момент %.1F Нм.'
    + LineEnding
    + 'Якщо обертальний момент в допустимих межах, спробуйте змінити виробника редуктора.';
  L10nOut[27, Rus] :=
    'Невозможно подобрать стандартный редуктор. ' +
    'Минимальный крутящий момент %.1F Нм.' +
    LineEnding +
    'Если крутящий момент в допустимых пределах, попробуйте поменять производителя редуктора.';

  L10nOut[28, Eng] :=
    'It is impossible to select a standard actuator. ' +
    'Minimum torque %.1F Nm. Minimum speed %.1F rpm.';
  L10nOut[28, Ukr] := 'Неможливо вибрати стандартний привід. Мінімальний обертальний момент %.1F Нм. Мінімальна швидкість обертання %.1F об/хв.';
  L10nOut[28, Rus] :=
    'Невозможно подобрать стандартный привод. ' +
    'Минимальный крутящий момент %.1F Нм. ' +
    'Минимальная скорость вращения %.1F об/мин.';

  L10nOut[29, Eng] := 'Actuator AUMA %S%S';
  L10nOut[29, Ukr] := 'Мотор-редуктор AUMA %S%S';
  L10nOut[29, Rus] := 'Мотор-редуктор AUMA %S%S';

  L10nOut[30, Eng] := 'Actuator %S';
  L10nOut[30, Ukr] := 'Мотор-редуктор %S';
  L10nOut[30, Rus] := 'Мотор-редуктор %S';

  L10nOut[31, Eng] := 'Output speed %.1F rpm';
  L10nOut[31, Ukr] := 'Швидкість обертання %.1F об/хв';
  L10nOut[31, Rus] := 'Скорость вращения %.1F об/мин';

  L10nOut[32, Eng] := 'Electric power %.2F kW';
  L10nOut[32, Ukr] := 'Потужність %.2F кВт';
  L10nOut[32, Rus] := 'Мощность %.2F кВт';

  L10nOut[33, Eng] := 'Torque %.0F…%.0F Nm';
  L10nOut[33, Ukr] := 'Обертальний момент %.0F…%.0F Нм';
  L10nOut[33, Rus] := 'Крутящий момент %.0F…%.0F Нм';

  L10nOut[34, Eng] := 'Flange type %S';
  L10nOut[34, Ukr] := 'Приєднувальний фланець %S';
  L10nOut[34, Rus] := 'Присоединительный фланец %S';

  L10nOut[35, Eng] := 'Valve attachment %S';
  L10nOut[35, Ukr] := 'Приєднувальна втулка %S';
  L10nOut[35, Rus] := 'Присоединительная втулка %S';

  L10nOut[36, Eng] := 'Type of duty %S';
  L10nOut[36, Ukr] := 'Короткочасний режим роботи %S';
  L10nOut[36, Rus] := 'Кратковременный режим работы %S';

  L10nOut[37, Eng] := 'Right-hand closing (clockwise)';
  L10nOut[37, Ukr] := 'Правостороннє закриття (за годинниковою стрілкою)';
  L10nOut[37, Rus] := 'Правостороннее закрытие (по часовой стрелке)';

  L10nOut[38, Eng] := 'Torque %.0F Nm for opening, %.0F Nm for closing';
  L10nOut[38, Ukr] := 'Обертальний момент на відкриття %.0F Нм, на закриття %.0F Нм';
  L10nOut[38, Rus] := 'Крутящий момент на открытие %.0F Нм, на закрытие %.0F Нм';

  L10nOut[39, Eng] := 'Full opening through %.1F min (%.1F sec) and %.1F rev';
  L10nOut[39, Ukr] := 'Повне відкриття через %.1F хв (%.1F сек) та %.1F оборотів';
  L10nOut[39, Rus] := 'Полное открытие через %.1F мин (%.1F сек) и %.1F оборотов';

  L10nOut[40, Eng] := 'Temperature range %.0F °C to %.0F °C';
  L10nOut[40, Ukr] := 'Температурний діапазон від %.0F °C до %.0F °C';
  L10nOut[40, Rus] := 'Температурный диапазон от %.0F °C до %.0F °C';

  L10nOut[41, Eng] := 'Voltage %.0F V / %.0F Hz / 3ph';
  L10nOut[41, Ukr] := 'Напруга живлення %.0F В / %.0F Гц / 3ф';
  L10nOut[41, Rus] := 'Напряжение питания %.0F В / %.0F Гц / 3ф';

  L10nOut[42, Eng] := 'General industrial design';
  L10nOut[42, Ukr] := 'Загальнопромислове виконання';
  L10nOut[42, Rus] := 'Общепромышленное исполнение';

  L10nOut[43, Eng] := 'Enclosure protection — IP 68';
  L10nOut[43, Ukr] := 'Ступінь захисту оболонки — IP 68';
  L10nOut[43, Rus] := 'Степень защиты оболочки — IP 68';

  L10nOut[44, Eng] := 'Corrosion protection — KS';
  L10nOut[44, Ukr] := 'Антикорозійний захист оболонки — KS';
  L10nOut[44, Rus] := 'Антикоррозионная защита оболочки — KS';

  L10nOut[45, Eng] := 'Limit switches — single';
  L10nOut[45, Ukr] := 'Кінцеві вимикачі — одиночні';
  L10nOut[45, Rus] := 'Концевые выключатели — одиночные';

  L10nOut[46, Eng] := 'Intermediate position switches — no';
  L10nOut[46, Ukr] := 'Проміжні вимикачі — ні';
  L10nOut[46, Rus] := 'Промежуточные выключатели — нет';

  L10nOut[47, Eng] := 'Torque switches — single';
  L10nOut[47, Ukr] := 'Моментні вимикачі — одиночні';
  L10nOut[47, Rus] := 'Моментные выключатели — одиночные';

  L10nOut[48, Eng] := 'Blinker transmitter — yes';
  L10nOut[48, Ukr] := 'Індикатор роботи приводу — так';
  L10nOut[48, Rus] := 'Индикатор работы привода — да';

  L10nOut[49, Eng] := 'Mechanical position indication — no';
  L10nOut[49, Ukr] := 'Механічний покажчик положення — ні';
  L10nOut[49, Rus] := 'Механический указатель положения — нет';

  L10nOut[50, Eng] := 'Stem protection tube — no';
  L10nOut[50, Ukr] := 'Захисна труба для висувного штока — ні';
  L10nOut[50, Rus] := 'Защитная труба для выдвижного штока — нет';

  L10nOut[51, Eng] := 'Electronic position transmitter — no';
  L10nOut[51, Ukr] := 'Дистанційний покажчик положення — ні';
  L10nOut[51, Rus] := 'Дистанционный указатель положения — нет';

  L10nOut[52, Eng] := 'Cable glands — yes';
  L10nOut[52, Ukr] := 'Комплект кабельних вводів — так';
  L10nOut[52, Rus] := 'Комплект кабельных вводов — да';

  L10nOut[53, Eng] := 'Cable type — unarmoured';
  L10nOut[53, Ukr] := 'Тип кабелю — неброньований';
  L10nOut[53, Rus] := 'Тип кабеля — небронированный';

  L10nOut[54, Eng] := 'Outside cable diameter — standard';
  L10nOut[54, Ukr] := 'Зовнішній діаметр кабелю — стандарт';
  L10nOut[54, Rus] := 'Наружный диаметр кабеля — стандарт';

  L10nOut[55, Eng] := 'Actuator controls %S';
  L10nOut[55, Ukr] := 'Блок керування %S';
  L10nOut[55, Rus] := 'Блок управления %S';

  L10nOut[56, Eng] := 'Spur gearbox %S %S';
  L10nOut[56, Ukr] := 'Циліндричний редуктор %S %S';
  L10nOut[56, Rus] := 'Цилиндрический редуктор %S %S';

  L10nOut[57, Eng] := 'Ratio %.1G (%.1G)';
  L10nOut[57, Ukr] := 'Передатне відношення %.1G (%.1G)';
  L10nOut[57, Rus] := 'Передаточное отношение %.1G (%.1G)';

  L10nOut[58, Eng] := 'Right angle gearbox %S %S';
  L10nOut[58, Ukr] := 'Кутовий редуктор %S %S';
  L10nOut[58, Rus] := 'Угловой редуктор %S %S';

  L10nOut[59, Eng] := 'Max torque %.0F Nm';
  L10nOut[59, Ukr] := 'Максимальний обертальний момент %.0F Нм';
  L10nOut[59, Rus] := 'Максимальный крутящий момент %.0F Нм';

  L10nOut[60, Eng] := 'Self-made two-armed handle D ≥ %.0F mm';
  L10nOut[60, Ukr] := 'Двоплеча рукоятка власного виготовлення D ≥ %.0F мм';
  L10nOut[60, Rus] := 'Двуплечая рукоятка собственного изготовления D ≥ %.0F мм';

  L10nOut[61, Eng] := 'Handwheel %S';
  L10nOut[61, Ukr] := 'Штурвал %S';
  L10nOut[61, Rus] := 'Штурвал %S';

  L10nOut[62, Eng] := 'Incorrect value.';
  L10nOut[62, Ukr] := 'Неправильне значення.';
  L10nOut[62, Rus] := 'Неправильное значение.';

  L10nOut[63, Eng] := 'Sheet %G mm stainless steel — %.1F kg';
  L10nOut[63, Ukr] := 'Лист %G мм нерж. — %.1F кг';
  L10nOut[63, Rus] := 'Лист %G мм нерж. — %.1F кг';

  L10nOut[64, Eng] := 'Calculated torque %.0F Nm';
  L10nOut[64, Ukr] := 'Розрахунковий обертальний момент %.0F Нм';
  L10nOut[64, Rus] := 'Расчетный крутящий момент %.0F Нм';

  L10nOut[65, Eng] := 'Leakage %.1F l/min';
  L10nOut[65, Ukr] := 'Витік %.1F л/хв';
  L10nOut[65, Rus] := 'Утечки %.1F л/мин';

  L10nOut[66, Eng] := 'Bronze nut %S Ø%.0F, L=%.0F';
  L10nOut[66, Ukr] := 'Гайка бронзова %S Ø%.0F, L=%.0F';
  L10nOut[66, Rus] := 'Гайка бронзовая %S Ø%.0F, L=%.0F';

  L10nOut[67, Eng] := 'Installation by concreting';
  L10nOut[67, Ukr] := 'Штрабний монтаж';
  L10nOut[67, Rus] := 'Штрабной монтаж';

  L10nOut[68, Eng] := 'Installation by anchoring to channel';
  L10nOut[68, Ukr] := 'Безштрабний монтаж';
  L10nOut[68, Rus] := 'Бесштрабной монтаж';

  L10nOut[69, Eng] := 'Installation by anchoring to wall';
  L10nOut[69, Ukr] := 'Настінний монтаж';
  L10nOut[69, Rus] := 'Настенный монтаж';

  L10nOut[70, Eng] := 'Installation by flange';
  L10nOut[70, Ukr] := 'Монтаж на фланці';
  L10nOut[70, Rus] := 'Монтаж на фланце';

  L10nOut[71, Eng] := 'Installation by two flanges';
  L10nOut[71, Ukr] := 'Монтаж на двох фланцях';
  L10nOut[71, Rus] := 'Монтаж на двух фланцах';

  L10nOut[72, Eng] := 'Non-rising spindle';
  L10nOut[72, Ukr] := 'Невисувний гвинт';
  L10nOut[72, Rus] := 'Невыдвижной винт';

  L10nOut[73, Eng] := 'Rising spindle';
  L10nOut[73, Ukr] := 'Висувний гвинт';
  L10nOut[73, Rus] := 'Выдвижной винт';

  L10nOut[74, Eng] := 'Only bevel reducers are used with two screws.';
  L10nOut[74, Ukr] := 'З двома гвинтами використовуються лише кутові редуктори.';
  L10nOut[74, Rus] := 'С двумя винтами используются только угловые редукторы.';

  L10nOut[75, Eng] := 'Sealing length is %.1F m';
  L10nOut[75, Ukr] := 'Довжина ущільнення %.1F м';
  L10nOut[75, Rus] := 'Длина уплотнения %.1F м';

  L10nOut[76, Eng] := 'Equation File';
  L10nOut[76, Ukr] := 'Файл рівнянь';
  L10nOut[76, Rus] := 'Файл уравнений';

  L10nOut[77, Eng] := 'For the design engineer';
  L10nOut[77, Ukr] := 'Для конструктора';
  L10nOut[77, Rus] := 'Для конструктора';

  L10nOut[78, Eng] := ' (right-hand)';
  L10nOut[78, Ukr] := ' (права)';
  L10nOut[78, Rus] := ' (правая)';

  L10nOut[79, Eng] := ' (left-hand)';
  L10nOut[79, Ukr] := ' (ліва)';
  L10nOut[79, Rus] := ' (левая)';

  L10nOut[80, Eng] := ' with a control column';
  L10nOut[80, Ukr] := ' з колонкою керування';
  L10nOut[80, Rus] := ' с колонкой управления';

  L10nOut[81, Eng] := ' with a remote bracket';
  L10nOut[81, Ukr] := ' з виносним кронштейном';
  L10nOut[81, Rus] := ' с выносным кронштейном';

  L10nOut[82, Eng] := 'Number of anchors m2r: M12 — %D min, M16 — %D min';
  L10nOut[82, Ukr] := 'Кількість анкерів m2r: М12 — щонайменше %D, М16 — щонайменше %D';
  L10nOut[82, Rus] := 'Кол-во анкеров m2r: М12 — не менее %D, М16 — не менее %D';

  L10nOut[83, Eng] := 'With handwheel Ø%.0F';
  L10nOut[83, Ukr] := 'Зі штурвалом Ø%.0F';
  L10nOut[83, Rus] := 'Со штурвалом Ø%.0F';

  L10nOut[84, Eng] := 'Stem nut is missing';
  L10nOut[84, Ukr] := 'Ходова гайка відсутня';
  L10nOut[84, Rus] := 'Ходовая гайка отсутствует';

  L10nOut[85, Eng] := ' small';
  L10nOut[85, Ukr] := ' малий';
  L10nOut[85, Rus] := ' малый';

  L10nOut[86, Eng] := 'Without protective cap';
  L10nOut[86, Ukr] := 'Без захисного ковпака';
  L10nOut[86, Rus] := 'Без защитного колпака';

  L10nOut[87, Eng] := 'Ambient working environment temperature -63…+50C';
  L10nOut[87, Ukr] := 'Температура навколишнього робочого середовища -63…+50С';
  L10nOut[87, Rus] := 'Температура окружающей рабочей среды -63…+50С';

  L10nOut[88, Eng] := 'Without explosion protection';
  L10nOut[88, Ukr] := 'Без вибухозахисту';
  L10nOut[88, Rus] := 'Без взрывозащиты';

  L10nOut[89, Eng] := 'Contact the design department for weight calculations.';
  L10nOut[89, Ukr] := 'За розрахунком маси звертайтеся в конструкторський відділ.';
  L10nOut[89, Rus] := 'За расчетом массы обращайтесь в конструкторский отдел.';

  L10nOut[90, Eng] := 'Weight is %.0F kg';
  L10nOut[90, Ukr] := 'Вага %.0F кг';
  L10nOut[90, Rus] := 'Вес %.0F кг';

  L10nOut[91, Eng] := 'Penstock %.0F kg, аrame %.0F kg, gate %.0F kg';
  L10nOut[91, Ukr] := 'Затвор %.0F кг, рама %.0F кг, щит %.0F кг';
  L10nOut[91, Rus] := 'Затвор %.0F кг, рама %.0F кг, щит %.0F кг';

  L10nOut[92, Eng] := 'Without handwheel';
  L10nOut[92, Ukr] := 'Без штурвалу';
  L10nOut[92, Rus] := 'Без штурвала';

  L10nOut[93, Eng] := 'Actuator weight is %.0F kg, weight of the control is %.0F kg';
  L10nOut[93, Ukr] := 'Вага приводу %.0F кг, блока керування %.0F кг';
  L10nOut[93, Rus] := 'Вес привода %.0F кг, блока управления %.0F кг';

  L10nOut[94, Eng] := 'Closing down, opening up';
  L10nOut[94, Ukr] := 'Закриття вниз, відкриття вгору';
  L10nOut[94, Rus] := 'Закрытие вниз, открытие вверх';

  L10nOut[95, Eng] := 'Closing up, opening down';
  L10nOut[95, Ukr] := 'Закриття вгору, відкриття вниз';
  L10nOut[95, Rus] := 'Закрытие вверх, открытие вниз';

  (*
  L10nOut[, Eng] := '';
  L10nOut[, Ukr] := '';
  L10nOut[, Rus] := '';

  L10nOut[, Eng] := '';
  L10nOut[, Ukr] := '';
  L10nOut[, Rus] := '';
  *)

  L10nGui[0, Eng] := 'Surface';
  L10nGui[0, Ukr] := 'Поверхневий';
  L10nGui[0, Rus] := 'Поверхностный';

  L10nGui[1, Eng] := 'Sealing on three sides.' + sLineBreak +
    'Closing down, opening up.' + sLineBreak + 'Screw with left-hand thread.';
  L10nGui[1, Ukr] := 'Ущільнення із трьох сторін.' + sLineBreak +
    'Закриття вниз, відкриття вгору.' + sLineBreak + 'Гвинт з лівим різьбленням.';
  L10nGui[1, Rus] := 'Уплотнение по трем сторонам.' + sLineBreak +
    'Закрытие вниз, открытие вверх.' + sLineBreak + 'Винт с левой резьбой.';

  L10nGui[2, Eng] := 'The hydrostatic head is equal to the height of the gate.';
  L10nGui[2, Ukr] := 'Гідростатичний напір дорівнює висоті щита.';
  L10nGui[2, Rus] := 'Гидростатический напор равен высоте щита.';

  L10nGui[3, Eng] := 'Installation';
  L10nGui[3, Ukr] := 'Встановлення';
  L10nGui[3, Rus] := 'Установка';

  L10nGui[4, Eng] := 'Concreting in a channel';
  L10nGui[4, Ukr] := 'Штрабне';
  L10nGui[4, Rus] := 'Штрабная';

  L10nGui[5, Eng] := 'Anchoring in a channel';
  L10nGui[5, Ukr] := 'Безштрабне';
  L10nGui[5, Rus] := 'Бесштрабная';

  L10nGui[6, Eng] := 'Anchoring to the wall';
  L10nGui[6, Ukr] := 'Настінне';
  L10nGui[6, Rus] := 'Настенная';

  L10nGui[7, Eng] := 'Deep';
  L10nGui[7, Ukr] := 'Глибинний';
  L10nGui[7, Rus] := 'Глубинный';

  L10nGui[8, Eng] := 'Sealing on four sides.' + sLineBreak +
    'Closing down, opening up.' + sLineBreak + 'Screw with left-hand thread.';
  L10nGui[8, Ukr] := 'Ущільнення із чотирьох сторін.' + sLineBreak +
    'Закриття вниз, відкриття вгору.' + sLineBreak + 'Гвинт з лівим різьбленням.';
  L10nGui[8, Rus] := 'Уплотнение по четырем сторонам.' + sLineBreak +
    'Закрытие вниз, открытие вверх.' + sLineBreak +
    'Винт с левой резьбой.';

  L10nGui[9, Eng] := 'Hydrostatic head (m):';
  L10nGui[9, Ukr] := 'Гідростатичний тиск (м):';
  L10nGui[9, Rus] := 'Гидростатический напор (м):';

  L10nGui[10, Eng] := 'Concreting to the wall (with shell)';
  L10nGui[10, Ukr] := 'Штрабне (з обічайкою)';
  L10nGui[10, Rus] := 'Штрабная (с обечайкой)';

  L10nGui[11, Eng] := 'With flange';
  L10nGui[11, Ukr] := 'На фланці';
  L10nGui[11, Rus] := 'На фланце';

  L10nGui[12, Eng] := 'With mating flange(s)';
  L10nGui[12, Ukr] := 'З відповідним(и) фланцем(-ями)';
  L10nGui[12, Rus] := 'С ответным(и) фланцем(-ами)';

  L10nGui[13, Eng] := 'With two flanges (with sealed frame)';
  L10nGui[13, Ukr] := 'На двох фланцях (з герметичною рамою)';
  L10nGui[13, Rus] := 'На двух фланцах (с герметичной рамой)';

  L10nGui[14, Eng] := 'Regulating';
  L10nGui[14, Ukr] := 'Регулюючий';
  L10nGui[14, Rus] := 'Регулирующий';

  L10nGui[15, Eng] := 'Sealing on three sides.' + sLineBreak +
    'Close up, open down.' + sLineBreak + 'Screw with right-hand thread.';
  L10nGui[15, Ukr] := 'Ущільнення із трьох сторін.' + sLineBreak +
    'Закриття нагору, відкриття вниз.' + sLineBreak + 'Гвинт з правим різьбленням.';
  L10nGui[15, Rus] := 'Уплотнение по трем сторонам.' + sLineBreak +
    'Закрытие вверх, открытие вниз.' + sLineBreak + 'Винт с правой резьбой.';

  L10nGui[16, Eng] := 'Concreting in a channel (with a fixed gate)';
  L10nGui[16, Ukr] := 'Штрабне (з нерухомим щитом)';
  L10nGui[16, Rus] := 'Штрабная (с неподвижным щитом)';

  L10nGui[17, Eng] := 'Anchoring in a channel (with a fixed gate)';
  L10nGui[17, Ukr] := 'Безштрабне (з нерухомим щитом)';
  L10nGui[17, Rus] := 'Бесштрабная (с неподвижным щитом)';

  L10nGui[18, Eng] := 'Between the tops of frame and gate (m):';
  L10nGui[18, Ukr] := 'Від верха рами до верха щита (м):';
  L10nGui[18, Rus] := 'От верха рамы до верха щита (м):';

  L10nGui[19, Eng] := 'Penstock dimensions';
  L10nGui[19, Ukr] := 'Розміри затвору';
  L10nGui[19, Rus] := 'Размеры затвора';

  L10nGui[20, Eng] := 'Frame width (m):';
  L10nGui[20, Ukr] := 'Ширина рами (м):';
  L10nGui[20, Rus] := 'Ширина рамы (м):';

  L10nGui[21, Eng] := 'Frame height (m):';
  L10nGui[21, Ukr] := 'Висота рами (м):';
  L10nGui[21, Rus] := 'Высота рамы (м):';

  L10nGui[22, Eng] := 'Gate height (m):';
  L10nGui[22, Ukr] := 'Висота щита (м):';
  L10nGui[22, Rus] := 'Высота щита (м):';

  L10nGui[23, Eng] := 'Liquid density (kg/m3):';
  L10nGui[23, Ukr] := 'Щільність рідини (кг/м3):';
  L10nGui[23, Rus] := 'Плотность жидкости (кг/м3):';

  L10nGui[24, Eng] := 'Screw';
  L10nGui[24, Ukr] := 'Гвинт';
  L10nGui[24, Rus] := 'Винт';

  L10nGui[25, Eng] := 'Non rising';
  L10nGui[25, Ukr] := 'Невисувний';
  L10nGui[25, Rus] := 'Невыдвижной';

  L10nGui[26, Eng] := 'Rising';
  L10nGui[26, Ukr] := 'Висувний';
  L10nGui[26, Rus] := 'Выдвижной';

  L10nGui[27, Eng] := 'Two screws';
  L10nGui[27, Ukr] := 'Два гвинти';
  L10nGui[27, Rus] := 'Два винта';

  L10nGui[28, Eng] := 'For engineer';
  L10nGui[28, Ukr] := 'Для інженера';
  L10nGui[28, Rus] := 'Для инженера';

  L10nGui[29, Eng] := 'Screw TrxS (mm):';
  L10nGui[29, Ukr] := 'Гвинт TrxS (мм):';
  L10nGui[29, Rus] := 'Винт TrxS (мм):';

  L10nGui[30, Eng] := 'Opening height (m):';
  L10nGui[30, Ukr] := 'Висота відкриття (м):';
  L10nGui[30, Rus] := 'Высота открытия (м):';

  L10nGui[31, Eng] := 'Frame sheet (mm):';
  L10nGui[31, Ukr] := 'Лист рами (мм):';
  L10nGui[31, Rus] := 'Лист рамы (мм):';

  L10nGui[32, Eng] := 'Gate sheet (mm):';
  L10nGui[32, Ukr] := 'Лист щита (мм):';
  L10nGui[32, Rus] := 'Лист щита (мм):';

  L10nGui[33, Eng] := 'Without intermediate supports in the frame';
  L10nGui[33, Ukr] := 'Без проміжних опор у рамі';
  L10nGui[33, Rus] := 'Без промежуточных опор в раме';

  L10nGui[34, Eng] := 'Three pairs of wedges';
  L10nGui[34, Ukr] := 'Три пари клинів';
  L10nGui[34, Rus] := 'Три пары клиньев';

  L10nGui[35, Eng] := 'Gearmotor';
  L10nGui[35, Ukr] := 'Мотор-редуктор';
  L10nGui[35, Rus] := 'Мотор-редуктор';

  L10nGui[36, Eng] := 'For opening-closing';
  L10nGui[36, Ukr] := 'Для відкриття-закриття';
  L10nGui[36, Rus] := 'Для открытия-закрытия';

  L10nGui[37, Eng] := 'For regulation';
  L10nGui[37, Ukr] := 'Для регулювання';
  L10nGui[37, Rus] := 'Для регулирования';

  L10nGui[38, Eng] := 'Prefer a rotation speed of at least (rpm):';
  L10nGui[38, Ukr] := 'Віддавати перевагу швидкості обертання не менше (об/хв):';
  L10nGui[38, Rus] := 'Предпочитать скорость вращения не менее (об/мин):';

  L10nGui[39, Eng] := 'The number of full turns of the gate before the drive overheats:';
  L10nGui[39, Ukr] := 'Кількість повних ходів щита до перегріву приводу:';
  L10nGui[39, Rus] := 'Количество полных ходов щита до перегрева привода:';

  L10nGui[40, Eng] := 'Manual gearbox';
  L10nGui[40, Ukr] := 'Ручний редуктор';
  L10nGui[40, Rus] := 'Ручной редуктор';

  L10nGui[41, Eng] := 'Bevel';
  L10nGui[41, Ukr] := 'Конічний';
  L10nGui[41, Rus] := 'Угловой';

  L10nGui[42, Eng] := 'Spur';
  L10nGui[42, Ukr] := 'Циліндричний';
  L10nGui[42, Rus] := 'Цилиндрический';

  L10nGui[43, Eng] :=
    'With two screws AUMA GK and RZAM can only be used with an electric drive.' + sLineBreak +
    'Tramec can only be used with non-retractable screw(s).' + sLineBreak +
    'The spur gearbox can only be used with one screw.';
  L10nGui[43, Ukr] :=
    'З двома гвинтами AUMA GK та РЗАМ можна використовувати тільки з електроприводом.' + sLineBreak +
    'Tramec можна використовувати тільки з невисувним(и) гвинтом(-ами).' + sLineBreak +
    'Циліндричний редуктор можна використовувати лише з одним гвинтом.';
  L10nGui[43, Rus] :=
    'С двумя винтами AUMA GK и РЗАМ можно использовать только с электроприводом.' + sLineBreak +
    'Tramec можно использовать только с невыдвижным(и) винтом(-ами).' + sLineBreak +
    'Цилиндрический редуктор можно использовать только с одним винтом.';

  L10nGui[44, Eng] := 'Handwheel';
  L10nGui[44, Ukr] := 'Штурвал';
  L10nGui[44, Rus] := 'Штурвал';

  L10nGui[45, Eng] := 'Purchased handwheels Ø%.0F…%.0F can be used:' + LineEnding +
    '— with low torque,' + LineEnding +
    '— with non-rising screws of any size,' + LineEnding +
    '— with rising screws with a diameter of not more than %.0F mm.' + LineEnding +
    'In other cases it is necessary to use the two-shouldered handle of own production.';
  L10nGui[45, Ukr] := 'Покупні штурвали Ø%.0F…%.0F можна використовувати:' + LineEnding +
    '— при невеликому обертаючому моменті,' + LineEnding +
    '— з невисувними гвинтами будь-яких розмірів,' + LineEnding +
    '— з висувними гвинтами діаметром не більше %.0F мм.' + LineEnding +
    'В інших випадках необхідно використовувати двоплечу рукоятку власного виготовлення.';
  L10nGui[45, Rus] := 'Покупные штурвалы Ø%.0F…%.0F можно использовать:' + LineEnding +
    '— при небольшом крутящем моменте,' + LineEnding +
    '— с невыдвижными винтами любых размеров,' + LineEnding +
    '— с выдвижными винтами диаметром не более %.0F мм.' + LineEnding +
    'В остальных случаях необходимо использовать двуплечую рукоятку собственного изготовления.';

  L10nGui[46, Eng] := 'Location of the drive or handwheel';
  L10nGui[46, Ukr] := 'Розташування приводу або штурвалу';
  L10nGui[46, Rus] := 'Расположение привода или штурвала';

  L10nGui[47, Eng] := 'On the frame';
  L10nGui[47, Ukr] := 'На рамі затвору';
  L10nGui[47, Rus] := 'На раме затвора';

  L10nGui[48, Eng] := 'Standard placement on the top beam of the frame.';
  L10nGui[48, Ukr] := 'Стандартне розміщення на верхній балці рами.';
  L10nGui[48, Rus] := 'Стандартное размещение на верхней балке рамы.';

  L10nGui[49, Eng] := 'Control column';
  L10nGui[49, Ukr] := 'Колонка керування';
  L10nGui[49, Rus] := 'Колонка управления';

  L10nGui[50, Eng] := 'Control column height 760 mm.';
  L10nGui[50, Ukr] := 'Висота колонки керування 760 мм.';
  L10nGui[50, Rus] := 'Высота колонки управления 760 мм.';

  L10nGui[51, Eng] := 'From top of frame to ground (m):';
  L10nGui[51, Ukr] := 'Від верху рами до землі (м):';
  L10nGui[51, Rus] := 'От верха рамы до земли (м):';

  L10nGui[52, Eng] := 'Without intermediate supports on the pipe';
  L10nGui[52, Ukr] := 'Без проміжних опор на трубі';
  L10nGui[52, Rus] := 'Без промежуточных опор на трубе';

  L10nGui[53, Eng] := 'Angle bracket';
  L10nGui[53, Ukr] := 'Кронштейн';
  L10nGui[53, Rus] := 'Кронштейн';

  L10nGui[54, Eng] := 'Outrigger with wall mount.';
  L10nGui[54, Ukr] := 'Виносна опора із настінним кріпленням.';
  L10nGui[54, Rus] := 'Выносная опора с настенным креплением.';

  L10nGui[55, Eng] := 'Run';
  L10nGui[55, Ukr] := 'Рахувати';
  L10nGui[55, Rus] := 'Расчет';
  (*
  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

  L10nGui[, Rus] := '';
  L10nGui[, Ukr] := '';
  L10nGui[, Eng] := '';

                   *)
end.

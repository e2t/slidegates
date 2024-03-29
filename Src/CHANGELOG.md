# Лог изменений

[//]: # "YYYY-MM-DD"
[//]: # "Added, Changed, Fixed, Deprecated, Removed, Security"

## [23.1] - 2023-12-20

### Added

- Додано напрямок закриття щита (вгору чи вниз) до характеристик приводу.

## [2.8.0] - 2023-05-15

### Changed

- Змінено розрахунок ваги глибинних затворів.
- Уточнено розрахунок ваги колонки управління, проміжної труби та опор.

### Added

- Додано вагу редукторів, блоків керування та штурвалів (виводиться окремо). 

### Fixed

- Штурвал редуктору відображатиметься, лише якщо це конічний редуктор, а затвор має один гвинт.

## [2.7.0] - 2023-04-28

### Added

- Додано перемикач параметрів електромережі (стан зберігається між викликами програми).

### Changed

- Вага затвору виводиться лише при навантаженні не більше 20 тонн.
- Параметри мотор-редукторів AUMA оновлені до сучасної версії каталогу.
- Бронзова смуга змінена на покупну деталь (для логістики). 

### Fixed

- Виправлено: вибір конкретної марки мотор-редуктору призводив до аварійного завершення під час розрахунку.
- Виправлено: мова результатів розрахунку зберігалась при кожному натисканні кнопки "Рахувати" (тепер — лише при зміні у спадному меню).     

## [2.6.0] - 2023-01-31

### Added

- Додано український переклад результатів розрахунку.

### Fixed

- Незначні виправлення українського перекладу інтерфейса. 

## [2.5.0] - 2022-04-25

### Добавлено

- Добавлена локализация интерфейса программы на украинском и английском языках.

### Изменения

- Уменьшено допустимое напряжение на срез (расчет штифтов и осей) с 80 до 60 МПа.
- Расширено описание редукторов РЗАМ.

## [2.4.0] - 2021-10-20

### Добавлено

- Добавлена возможность указать нестандартную толщину листового металла (влияет на массу затвора).
- Кроме общей массы затвора, теперь также выводятся массы рамы и щита.

## [2.3.0] - 2021-09-20

### Добавлено

- К обозначению затворов малой конструкции добавлена отметка «малый». 

### Изменения

- Изменен силовой расчет.
- Мотор-редукторы теперь подбираются с 15% запасом от расчетного крутящего момента.
- Крутящий момент и осевое усилие на винте выводятся в виде диапазона: от необходимого расчетного значения до ожидаемого максимального.

### Исправлено

- Уточнены передаточные отношения ручных редукторов всех марок.

## [2.2.0] - 2021-09-01

### Изменения

- Уточнен расчет массы регулирующих затворов.

### Исправлено

- При ручном указании винта не работала русская "х" в качестве разделителя (например, 30х6).

## [2.1.0] - 2021-07-21

### Добавлено

- Добавлены ручные редукторы Tramec, Rotork и ООО "Механик".
- Добавлена конфигурация затворов с двумя винтами.
- Добавлено минимальное количество анкеров для бесштрабного и настенного крепления.
- Добавлена длина уплотнения.
- Добавлен файл уравнений для малых затворов (для конструктора).

### Изменения

- Снижены допустимые нагрузки при использовании штурвалов (ГОСТ 21752-76). 
- Уточнен расчет осей бронзовой гайки или винта.
- Незначительные косметические изменения.

### Исправлено

- Бронзовая полоса больше не выводится для малых затворов.
- Исправлены типы редукторов в результатах расчета (угловой ↔ цилиндрический).

## [2.0.2] - 2021-05-06

### Изменения

- Добавлены размеры круглых бронзовых гаек HBD.

### Исправлено

- Исправлена ошибка при подборе маховиков.

## [2.0.1] - 2021-04-29

### Изменения

- Расширены названия блоков управления AM и AC в выпадающих списках.

### Исправлено

- Исправлена ошибка в расчете массы винта.

## [2.0.0] - 2021-04-27

### Изменения

- Переписан интерфейс.
- Изменена формула расчета нагрузки на винт.
- В расчете массы теперь учитывается вес промежуточной трубы для затворов с выносной опорой.
- Уменьшен запас прочности винта с 2,0 до 1,5.

### Добавлено

- Добавлена опция "С ответным фланцем" для глубинных затворов.
- Добавлен расчет допустимых утечек.

### Удалено

- Удалена конфигурация затворов с двумя винтами.

### Исправлено

- Уточнен расчет осей гайки.
- Исправлена ошибка в расчете массы обечайки.

## [1.4.1] - 2021-03-23

### Исправлено

- Для регулирующих затворов с двумя винтами масса винта не удваивалась.

## [1.4.0] - 2020-11-15

### Добавлено

- Возможность выбора цилиндрического редуктора AUMA GST.
- Указание для опции "Выдвижной винт", что привод не должен затапливаться.

### Изменения

- Временно заблокирована возможность ручного выбора конкретной марки редуктора.

### Исправлено

- Ошибка при проверке винта (из-за передаточного отношения редуктора).

## [1.3.3] - 2020-06-11

### Добавлено

- Коэффициент гибкости стержня (должен быть меньше 250).
- Марка покупной гайки и количество бронзовой полосы (для отдела логистики).

### Изменения

- Изменился расчет длины резьбовой части винта согласно последним изменениям конструкции.
- Для поверхностных и глубинных затворов используется винт с левой резьбой.
- Мотор-редуктор AUMA используется с правосторонним закрытием (по часовой стрелке) для всех типов затворов.

## [1.3.2] - 2020-04-20

### Изменения

- Обновлены обозначения регулирующих затворов: канальные - ЗЩКРР/SGCORM, настенные - ЗЩНРР/SGWORM.
- Тип регулирующего затвора (настенный или канальный) определяется по выбранному способу установки.
- При выборе блока управления AUMATIC теперь для всех приводов используется AC 01.2 (тип AC 01.1 снят с производства).
- Выходные данные: вместо "AISI 304" выводится более общее "нерж.".
- Окно программы: переливной тип затвора переименован в регулирующий.
- Окно программы: канальная установка переименована в бесштрабную.

### Удалено

- Диаметр прутка для собственного изготовления винтов.
- Флажок "с неподвижным щитом" для регулирующих затворов.

## [1.3.1] - 2020-03-20

### Добавлено

- Вывод минимального момента инерции винта.

### Исправлено

- Если был указан нестандартный ход щита, программа игнорировала это при расчете длины винта.

## [1.3.0] - 2020-02-27

### Изменения

- Изменен ряд стандартных винтов: вместо (30х6, 40х6, 55х6, 60х6, 65х6, 70х6, 75х6, 80х6, 85х6, 90х6) теперь используются (30х6, 40х7, 50х8, 60х9, 70х10, 80х10, 90х12). Это незначительно увеличивает массу, но снижает скорость и мощность приводов для больших затворов. Винты свыше 90х12 программой не подбираются (нестандартное изделие), но можно задавать вручную.

### Добавлено

- Добавлено текстовое поле для указания шага винта. Если диаметр резьбы задается вручную, должен быть задан и ее шаг.

## [1.2.0] - 2019-01-10

### Изменения

- Верхняя часть винта закрепляется иногда жестко, иногда шарнирно в разных конструкциях затворов, и расчет производился по схеме с шарнирным закреплением (наихудший случай). В дальнейшем конструктивно всегда будет обеспечиваться жесткое закрепление винта, что позволяет использовать коэффициент приведения длины 0,7 вместо 1,0: **μ = 1,0 → 0,7**

- Рекомендуемый запас прочности понижен до 2,0 вместо 2,4: **n = 2,4 → 2,0**

- Градация трапеций собственного изготовления (больше Tr55) понижена до 5 мм вместо 10 мм: **[30, 40, 55, 65, 75] → [30, 40, 55, 60, 65, 70, 75]**

## [1.1.6] - 2018-07-10

### Добавлено

- Температурный диапазон для приводов AUMA. Меняется в зависимости от типа привода (SA или SAR), а также наличия и типа блока управления.

### Изменения

- Переключатель "Ручной привод" переименован в "Ручной редуктор".

## [1.1.5] - 2017-12-13

### Добавлено

- Явно указывается направление резьбы винтов.

### Изменения

- Описание редукторов AUMA GK в затворах с двумя винтами поделено на две части: стандартный редуктор и с монтажным фланцем под привод.

- Улучшен английский перевод некоторых характеристик приводов.

- Диаметр круга выводится только для винтов меньше 50 мм.

- Предполагаемая длина заготовки винта увеличена на 100 мм.

### Удалено

- Промежуточные выключатели удалены из описания мотор-редуктора AUMA.

- Торцевая заглушка удалена из описания редукторов Tramec.

## [1.1.4] - 2017-11-06

### Изменения

- Толщина листа рамы 4 мм используется до размеров 1.25х1.25, свыше лист 5 мм.

## [1.1.3] - 2017-07-20

### Изменения

- Вместо стандартной резьбы 42х6 подбирается 40х6.
- Толщина рамы и щита перенесена в описание профилей.

## [1.1.0] - 2017-07-13

### Изменения

- Снижены требования для использования трех пар клиньев (было: напор 8 м и щит 2.0х2.0, стало: напор 4 м и щит 1.9х1.9).
- Значительно расширена информация о мотор-редукторе AUMA.
- Для затворов с ручным приводом и двумя невыдвижными винтами подбираются редукторы Tramec.

### Добавлено

- Сводка используемых материалов (листы, винт) для предварительного заказа.
- Возможность выбрать конкретную марку мотор-редуктора AUMA.
- Возможность выбрать конкретную марку ручного редуктора AUMA.
- Возможность задаться количеством пар клиньев.
- Возможность указать ход щита (м).

### Исправлено

- Неточность в расчете винта.

## [1.0.0] - 2017-01-01

### Changed

- Module recordlass replaced by namedlist
- DELTA_OPEN add into openning torque for every screw (5 Nm for one screw, 10 Nm for the two screws)

### Fixed

- Real torque in drive cannot be less than minimal torque of AUMA.
- AUMA MATIC (AM) showing again.

### Added

- Added note about minimal bolts for the all pairs

### Removed

- Some unused constants and functions

## [0.1.3] - 2016-12-06

### Fixed

- Designation: O -> SOR, DOR
- AUMA SAR for the regul slidegates starts from 10.2

## [0.1.2] - 2016-11-30

### Changed

- The some functions separated in other repository (dry).

## [0.1.1] - 2016-11-21

### Fixed

- Designation: SL -> SG
- Designation: OF -> O

### Added

- Left of right-hand closing for electric drive.

## [0.1.0] - 2016-11-18

- First release.

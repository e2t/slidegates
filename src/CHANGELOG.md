# Change Log

[//]: # (YYYY-MM-DD)
[//]: # (Added, Changed, Deprecated, Removed, Fixed, Security)

## [1.1.3] - 2017-07-20
Замена стандартной резьбы 42х6 на 40х6.
Толщина рамы и щита перенесена в описание профилей.

## [1.1.0] - 2017-07-13
Расчет:
Снижены требования для использования трех пар клиньев (было: напор 8 м и щит 2.0х2.0, стало: напор 4 м и щит 1.9х1.9).
Исправлена неточность в расчете винта.

Вывод результатов:
Добавлена сводка используемых материалов (листы, винт) для предварительного заказа.
Значительно расширена информация о мотор-редукторе AUMA.
Для затворов с ручным приводом и двумя невыдвижными винтами подбираются редукторы Tramec.

Интерфейс:
Добавлена возможность выбрать конкретную марку мотор-редуктора AUMA.
Добавлена возможность выбрать конкретную марку ручного редуктора AUMA.
Добавлена возможность задаться количеством пар клиньев.
Добавлена возможность указать ход щита (м).


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

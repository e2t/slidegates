# Лог изменений

[//]: # (YYYY-MM-DD)
[//]: # (Added, Changed, Deprecated, Removed, Fixed, Security)
[//]: # (Добавлено, Изменения, Устарело, Удалено, Исправлено, Безопасность)

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

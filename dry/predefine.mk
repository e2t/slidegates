ifeq ($(OS), Windows_NT)
PYTHON3 = python
SUPPRESS_ERROR = 2>nul
else
PYTHON3 = python3.6
SUPPRESS_ERROR = 2>/dev/null
endif

LANG_RU = lang/ru/LC_MESSAGES

TEST = test.py

SOURCES_PY = $(filter-out gui.py, $(wildcard *.py))

SOURCES_C = $(wildcard *.c)

OBJECTS = $(SOURCES_C:.c=.o)

VULTURE = vulture

CC = gcc

LDFLAGS ?= -shared -L$(DRY)

# https://lars-lab.jpl.nasa.gov/JPL_Coding_Standard_C.pdf
CFLAGS ?= -Wall -Wextra -pedantic -std=iso9899:1999 \
	-Wshadow -Wpointer-arith -Wcast-qual -Wcast-align \
	-Wstrict-prototypes -Wmissing-prototypes -Wconversion

# E701: multiple statements on one line (colon)
# E402: module level import not at top of file
PEP8 = pycodestyle --ignore=E701,E402

# E402: module level import not at top of file
FLAKE8 = flake8 --ignore=E402

MYPY = mypy --strict --ignore-missing-imports --follow-imports=silent \
	--config-file=../mypy.ini

# C0103: Invalid variable name
# C0111: Missing function docstring (missing-docstring)
# C0326: Exactly one space required around keyword argument assignment
# C0413: import '' should be placed at the top of the module
# E0611: no name '' in module '' (ImportError)
# E1101: module '' has no '' member
# I0011: locally disabling
# W0223: Method '' is abstract in class '' but is not overridden
# W0511: TODO
# R0902: too many instance attributes
# R0903: too few public methods
# R0912: too many branches
# R0913: Too many arguments
# R0914: too many local variables
# R0915: too many statements
PYLINT = pylint --score=n --reports=n \
	--init-hook="import sys; sys.path.append(f'{sys.path[0]}/..')" \
	--msg-template='{path}:{line}:{column}: {msg_id}: {msg} ({symbol})' \
	--disable=C0103,C0111,C0326,C0413,E0611,E1101,I0011,W0223,W0511,R0902,R0903,R0912,R0913,R0914,R0915 \
	$(SUPPRESS_ERROR)

PEP257 = pep257

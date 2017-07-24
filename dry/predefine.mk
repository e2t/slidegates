ifeq ($(OS), Windows_NT)
PYTHON3 = python
else
PYTHON3 = python3.6
endif

LANG_RU = lang/ru/LC_MESSAGES

SOURCES = $(wildcard *.py)

TEST = test.py

# C0103 - Invalid constant name
# C0111 - Missing function docstring
# C0326 - Exactly one space required around keyword argument assignment
# E0611 - no name '' in module '' (ImportError)
# E1101 - module '' has no '' member
# I0011 - locally disabling
# R0204 - redefinition of result type function
# R0902 - too many instance attributes
# R0903 - Too few public methods
# R0912 - too many branches
# R0913 - Too many arguments
# R0914 - Too many local variables
# R0915 - too many statements
# W0223 - Method '' is abstract in class '' but is not overridden
# W0511 - TODO
PYLINT = pylint -r n -s n --msg-template='{path}:{line}:{column}: {msg} {msg_id}'\
--disable=W0511,E0611,I0011,E1101,R0912,R0915,R0204,R0902,C0326,C0103,R0903,W0223,C0111,R0913,R0914

# E701 - multiple statements on one line
# E241 - multiple space after ','
# E221 - multiple spaces before operator
PEP8 = pep8 --ignore=E701,E241,E221

MYPY = mypy --strict --ignore-missing-imports --follow-imports=silent

# F401 - name imported but unused
# E241 - multiple space after ','
# E221 - multiple spaces before operator
FLAKE8 = flake8 --ignore=F401,E241,E221

VULTURE = vulture

PEP257 = pep257

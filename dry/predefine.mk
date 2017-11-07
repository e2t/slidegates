ifeq ($(OS), Windows_NT)
PYTHON3 = python
else
PYTHON3 = python3.6
endif

LANG_RU = lang/ru/LC_MESSAGES

SOURCES = $(filter-out gui.py, $(wildcard *.py))

TEST = test.py

PYLINT = pylint -r n -s n --msg-template='{path}:{line}:{column}: {msg} {msg_id}'

# E701 - multiple statements on one line
# E402 - module level import not at top of file
PEP8 = pep8 --ignore=E701,E402

# E402 - module level import not at top of file
FLAKE8 = flake8 --ignore=E402

MYPY = mypy --strict --ignore-missing-imports --follow-imports=silent

VULTURE = vulture

PEP257 = pep257

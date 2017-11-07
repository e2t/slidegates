%.mo: %.po
	msgfmt --check --check-accelerators=_ -o $@ $^

check: $(SOURCES)
ifdef FILE
	$(info Analyzing this file...)
	$(MYPY) '$(FILE)'
	$(PEP8) '$(FILE)'
	$(FLAKE8) '$(FILE)'
	$(PYTHON3) -m py_compile '$(FILE)'
	$(PEP257) '$(FILE)'
	$(PYLINT) '$(FILE)'
else
	$(info Analyzing the all files...)
	$(MYPY) $(SOURCES)
	$(PEP8) $(SOURCES)
	$(FLAKE8) $(SOURCES)
	$(PYTHON3) -m py_compile $(SOURCES)
	$(PEP257) $(SOURCES)
	$(VULTURE) $^
	$(PYLINT) $(SOURCES)
endif

gui.py: gui.ui
	pyuic5 -o $@ $^

run:
ifeq (, $(wildcard $(TEST)))
	$(PYTHON3) main.py
else
	$(PYTHON3) $(TEST)
endif

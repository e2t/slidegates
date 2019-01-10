ifeq ($(OS), Windows_NT)
DLL = $(DLLNAME).dll
else
DLL = $(DLLNAME).so
endif

mostlyclean:
	$(RM) $(OBJECTS)

clean: mostlyclean

%.mo: %.po
	msgfmt --check --check-accelerators=_ -o $@ $^

fastcheck: $(ARGS)
	$(MYPY) $^ || true
	$(PEP8) $^ || true

check: $(ARGS)
	make ARGS=$^ fastcheck
	$(PYLINT) $^ || true
	$(FLAKE8) $^ || true
	$(PEP257) $^ || true

checkall: $(SOURCES_PY)
	for i in $^ ; do make -s ARGS=$$i check ; done
	$(VULTURE) $^

gui.py: gui.ui
	pyuic5 -o $@ $^

def: $(OBJECTS)
	make -C $(DRY)
	$(LINK.o) -o $(DLL) $(OBJECTS) $(LDLIBS) -Wl,--output-def,$(DLLNAME).def,--out-implib,lib$(DLLNAME)dll.a

dll: $(DLL)

$(DLL): $(OBJECTS)
	make -C $(DRY)
	$(LINK.o) -o $@ $^ $(LDLIBS) $(DLLNAME).def -Wl,--out-implib,lib$(DLLNAME)_dll.a

run: 
ifeq (, $(wildcard $(TEST)))
	$(PYTHON3) main.py
else
	$(PYTHON3) $(TEST)
endif

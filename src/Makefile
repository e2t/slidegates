DRY = ../dry

include $(DRY)/predefine.mk

all: $(LANG_RU)/messages.mo $(SOURCES) gui.py
	make -C $(DRY)
	make run

include $(DRY)/postdefine.mk

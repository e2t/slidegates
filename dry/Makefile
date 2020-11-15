include predefine.mk

# all: $(LANG_RU)/common.mo libopenbsd_string.a
all: $(LANG_RU)/common.mo

libopenbsd_string.a: strlcat.o strlcpy.o
	ar rcs $@ $^

include postdefine.mk

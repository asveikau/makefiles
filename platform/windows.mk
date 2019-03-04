CC   := $(MAKEFILES_ROOT)win32-bin/cc
CXX  := $(CC)
NASM := nasm
STRIP:= echo
LIB  := $(MAKEFILES_ROOT)win32-bin/clwrapper-lib

EXESUFFIX:=.exe
LIBSUFFIX:=.lib
LIBWRAPPER=@echo Archiving $@ ... && $(LIB) /OUT:$@

CFLAGS+=\
   -DUNICODE \
   -D_UNICODE \
   -D_WINDOWS

CFLAGS+=-static-crt
LDFLAGS+=-static-crt

ifdef WIN64
CFLAGS += -mamd64
LDFLAGS += -mamd64
else
CFLAGS += -DXP_SUPPORT
XP_SUPPORT:=y
XP_SUPPORT_OBJS := \
   $(MAKEFILES_ROOT)src/xpsup-c.o \
   $(MAKEFILES_ROOT)src/xpsup.o
WINDOWS_SUBSYSTEM?=windows
LDFLAGS += $(XP_SUPPORT_OBJS) /link /subsystem:$(WINDOWS_SUBSYSTEM),5.01 /force

$(MAKEFILES_ROOT)src/xpsup-c.o: $(MAKEFILES_ROOT)src/xpsup-c.c
$(MAKEFILES_ROOT)src/xpsup.o: $(MAKEFILES_ROOT)src/xpsup.asm
	$(NASM) -f coff -o $@ $<
endif

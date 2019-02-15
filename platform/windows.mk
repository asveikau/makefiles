CXX  := cc
NASM := nasm
STRIP:= echo

EXESUFFIX:=.exe
LIBSUFFIX:=.lib
LIBWRAPPER=@echo Archiving $@ ... && clwrapper-lib /OUT:$@

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
LDFLAGS += $(XP_SUPPORT_OBJS) /link /subsystem:windows,5.01 /force

$(MAKEFILES_ROOT)src/xpsup-c.o: $(MAKEFILES_ROOT)src/xpsup-c.c
$(MAKEFILES_ROOT)src/xpsup.o: $(MAKEFILES_ROOT)src/xpsup.asm
	$(NASM) -f coff -o $@ $<
endif

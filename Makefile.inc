ifndef MAKEFILES_INC
MAKEFILES_INC:=y

ifneq ($(shell which winver.exe 2>/dev/null),)

WINDOWS:=y
PLATFORM:=windows
CXX:=cc
NASM:=nasm

EXESUFFIX:=.exe
LIBSUFFIX:=.lib
LIBWRAPPER=@echo Archiving $@ ... && clwrapper-lib /OUT:$@
STRIP:=echo

CFLAGS+=\
   -DUNICODE -D_UNICODE -D_WINDOWS
   
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

else
PLATFORM:=$(shell uname -s | tr '[:upper:]' '[:lower:]')
CXX:=c++
CXXFLAGS+=-std=c++11

LIBPREFIX:=lib
LIBSUFFIX:=.a
LIBWRAPPER=@echo Archiving $@ ... && rm -f $@ && ar cq $@
STRIP:=sh $(MAKEFILES_ROOT)scripts/strip.sh

ifeq ($(PLATFORM), linux)
CFLAGS+=-D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
endif

ifeq ($(PLATFORM), sunos)
CFLAGS+=-D__EXTENSIONS__ -D_POSIX_THREAD_SEMANTICS
endif

ifneq (, $(filter $(PLATFORM),freebsd openbsd))
CFLAGS+=-I/usr/local/include
LDFLAGS+=-L/usr/local/lib
endif

ifeq ($(PLATFORM),openbsd)
CXX:=clang
CXXLIBS+=-lstdc++
endif

ifneq ($(shell echo $(CXX) | grep -c g\+\+), 0)
CXXFLAGS+=-fpermissive
endif

endif

SRC2OBJ := sh $(MAKEFILES_ROOT)scripts/src2obj.sh
DEPEND := perl $(MAKEFILES_ROOT)scripts/depend.pl

CFLAGS+=-pthread
LDFLAGS+=-pthread

endif

#
# Common variables for reasonable Unix-like systems.
#

CC:=$(shell $(MAKEFILES_ROOT)scripts/find-cc.sh cc clang gcc)
CXX:=$(shell $(MAKEFILES_ROOT)scripts/find-cc.sh c++ clang++ g++)

ifeq (1, $(shell echo $(CC) | grep -c clang))
CFLAGS+=-Wno-unknown-warning-option
CFLAGS+=-Wno-gnu-zero-variadic-macro-arguments
CXXFLAGS+=-Wno-c99-extensions
endif

CXX_VERSION?=11
CXXFLAGS+=-std=c++${CXX_VERSION}

LIBPREFIX:=lib
LIBSUFFIX:=.a
SOSUFFIX:=.so
LIBWRAPPER=@echo Archiving $@ ... && rm -f $@ && ar cq $@
STRIP:=sh $(MAKEFILES_ROOT)scripts/strip.sh

ifndef NOSTDLIB
# The following was moved from per-platform makefiles since they
# may be more generally useful.
#
# /usr/local: important on FreeBSD and OpenBSD, may be good on others.
ifeq ($(shell [ -d /usr/local/lib ] && echo 1 || echo 0), 1)
LATE_CFLAGS+=-I/usr/local/include
LDFLAGS+=-L/usr/local/lib
endif
# /opt/local: important for MacPorts
ifeq ($(shell [ -d /opt/local/lib ] && echo 1 || echo 0; echo $?), 1)
LATE_CFLAGS+=-I/opt/local/include
LDFLAGS+=-L/opt/local/lib
endif
endif # !NOSTDLIB

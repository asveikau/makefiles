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

CXXFLAGS+=-std=c++11

LIBPREFIX:=lib
LIBSUFFIX:=.a
LIBWRAPPER=@echo Archiving $@ ... && rm -f $@ && ar cq $@
STRIP:=sh $(MAKEFILES_ROOT)scripts/strip.sh

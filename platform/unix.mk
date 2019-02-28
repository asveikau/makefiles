#
# Common variables for reasonable Unix-like systems.
#

CC:=$(shell $(MAKEFILES_ROOT)scripts/find-cc.sh cc clang gcc)
CXX:=$(shell $(MAKEFILES_ROOT)scripts/find-cc.sh c++ clang++ g++)

CXXFLAGS+=-std=c++11

LIBPREFIX:=lib
LIBSUFFIX:=.a
LIBWRAPPER=@echo Archiving $@ ... && rm -f $@ && ar cq $@
STRIP:=sh $(MAKEFILES_ROOT)scripts/strip.sh

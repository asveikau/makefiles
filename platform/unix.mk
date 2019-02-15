#
# Common variables for reasonable Unix-like systems.
#

CXX:=c++
CXXFLAGS+=-std=c++11

LIBPREFIX:=lib
LIBSUFFIX:=.a
LIBWRAPPER=@echo Archiving $@ ... && rm -f $@ && ar cq $@
STRIP:=sh $(MAKEFILES_ROOT)scripts/strip.sh

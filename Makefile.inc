ifndef MAKEFILES_INC
MAKEFILES_INC:=y

SRC2OBJ := sh $(MAKEFILES_ROOT)scripts/src2obj.sh
DEPEND := perl $(MAKEFILES_ROOT)scripts/depend.pl

ifneq ($(shell which winver.exe 2>/dev/null),)
WINDOWS:=y
PLATFORM:=windows
else
PLATFORM:=$(shell uname -s | tr '[:upper:]' '[:lower:]')
endif

ifndef WINDOWS
include $(MAKEFILES_ROOT)platform/unix.mk
endif
-include $(MAKEFILES_ROOT)platform/$(PLATFORM).mk

ifneq ($(shell echo $(CXX) | grep -c g\+\+), 0)
CXXFLAGS+=-fpermissive
endif

CFLAGS+=-pthread
LDFLAGS+=-pthread

endif

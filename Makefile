.PHONY: all all-phony clean
all: all-phony

include Makefile.inc

all-phony:
	@echo 'Nothing to see here.  Just makefiles.'

clean:
ifdef XP_SUPPORT_OBJS
	rm -f $(XP_SUPPORT_OBJS)
endif


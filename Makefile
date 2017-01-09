

subdirs = 1.44

LATEST=1.44

.PHONY: $(subdirs)

all: $(subdirs)
build: $(subdirs)
test: $(subdirs)
clean: $(subdirs)

$(subdirs):
	$(MAKE) -C $@  $(MAKECMDGOALS) LATEST=$(LATEST)
	


TARGETS = $(HOME)/.pryrc $(HOME)/.irbrc
SHELL = /bin/bash
CWD = $(shell pwd)

define check_file
	@if [[ -e $1 && "$(OVERWRITE)" != "1" ]]; then \
		echo "make install won't overwrite $1"; \
		echo "1) remove it yourself or 2) use 'make install OVERWRITE=1'"; \
		false \
	else true; \
	fi
endef

install: $(TARGETS)
	@[[ "${RUBY}" != "" ]] || (echo "use 'make install RUBY=1.9.3-p125' (use the ruby of your choice)"; false)
	rvm ${RUBY}@global do gem install pry pry-doc pry-rails pry-nav pry-stack_explorer coderay awesome_print gnuplot

$(HOME)/.%: %
	$(call check_file,$@)
	ln -fs $(PWD)/$< $@

update:
	git pull

.PHONY: install update

GEMS = pry pry-doc pry-debugger pry-stack_explorer awesome_print gnuplot coderay colorize
GEMS_NODEPS = commands rails-env-switcher rspec-console cucumber-console mongoid-colors
TARGETS = $(HOME)/.pryrc $(HOME)/.irbrc
SHELL = /bin/bash
CWD = $(shell pwd)
RVM=$(shell ls -d {~/.,/usr/local/}rvm 2>/dev/null | head -1)
RUBIES=$(shell ls ${RVM}/rubies | grep -v '^default$$')

define check_file
	@if [[ -e $1 && "$(OVERWRITE)" != "1" ]]; then \
		echo "make install won't overwrite $1"; \
		echo "1) remove it yourself or 2) use 'make install OVERWRITE=1'"; \
		false \
	else true; \
	fi
endef

bold=`tput bold`
normal=`tput sgr0`

all:
	@echo type make install

install: $(TARGETS)
	@echo -e "gems: ${bold}${GEMS} ${GEMS_NODEPS}${normal}\n"
	@for RUBY in ${RUBIES}; do echo Installing gems in ${bold}$$RUBY@global${normal}...; rvm $$RUBY@global do gem install ${GEMS} --no-ri --no-rdoc; rvm $$RUBY@global do gem install ${GEMS_NODEPS} --ignore-dependencies --no-ri --no-rdoc; rvm $$RUBY@global do gem cleanup; echo; done
	@echo "${bold}Enjoy !${normal}"

$(HOME)/.%: %
	$(call check_file,$@)
	ln -fs $(PWD)/$< $@

update:
	git pull
	+make install

.PHONY: install update

GEMS = pry pry-doc pry-debugger pry-stack_explorer awesome_print gnuplot coderay colorize
GEMS_NODEPS = commands rails-env-switcher rspec-console cucumber-console mongoid-colors
TARGETS = $(HOME)/.pryrc $(HOME)/.irbrc
SHELL = /bin/bash
CWD = $(shell pwd)
RVM=$(shell ls -d {~/.,/usr/local/}rvm 2>/dev/null | head -1)
RBENV=$(shell ls -d {~/.,/usr/local/}rbenv 2>/dev/null | head -1)

ifneq ($(RVM),)
  RUBIES=$(shell ls ${RVM}/rubies | grep -v '^default$$')
else ifneq ($(RBENV),)
  RUBIES=$(shell rbenv versions | sed 's/\*//g' | awk '{print $$1}' | grep -v system)
else
  $(error Please use rvm or rbenv)
endif

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
	@for RUBY in ${RUBIES}; do \
		if [ -n "${RVM}" ]; then \
			echo "[rvm] Installing gems for ${bold}$$RUBY@global${normal}..."; \
			rvm $$RUBY@global do gem install ${GEMS} --no-ri --no-rdoc; \
			rvm $$RUBY@global do gem install ${GEMS_NODEPS} --ignore-dependencies --no-ri --no-rdoc; \
			rvm $$RUBY@global do gem cleanup; \
		else \
			echo "[rbenv] Installing gems for ${bold}$$RUBY${normal}..."; \
			export RBENV_VERSION=$$RUBY; \
			rbenv rehash; \
			gem install ${GEMS} --install-dir ${RBENV}/versions/$$RUBY/lib/ruby/gems/irb-config --no-ri --no-rdoc; \
			gem install ${GEMS_NODEPS} --install-dir ${RBENV}/versions/$$RUBY/lib/ruby/gems/irb-config --ignore-dependencies --no-ri --no-rdoc; \
			GEM_HOME=${RBENV}/versions/$$RUBY/lib/ruby/gems/irb-config gem cleanup; \
		fi; \
		echo; \
	done
	@echo "${bold}Enjoy !${normal}"

$(HOME)/.%: %
	$(call check_file,$@)
	ln -fs $(PWD)/$< $@

update:
	git pull
	+make install

.PHONY: install update

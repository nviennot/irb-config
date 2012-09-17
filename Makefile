GEMS = pry pry-doc pry-rails pry-nav pry-stack_explorer coderay awesome_print gnuplot
TARGETS = $(HOME)/.pryrc $(HOME)/.irbrc
RVM_GLOBAL = ~/.rvm/gemsets/global.gems
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

bold=`tput bold`
normal=`tput sgr0`

install: $(TARGETS)
	@echo -e "gems: ${bold}${GEMS}${normal}\n"
	@rvm all do sh -c 'echo -e Installing gems for ${bold}$$RUBY_VERSION${normal}...; gem install ${GEMS}; echo'
	@echo "${bold}Setting up rvm to install these gems by default when installing a new ruby...${normal}"
	@echo $(GEMS) | xargs -L1 -d ' ' | cat $(RVM_GLOBAL) - | sort -u | grep . > $(RVM_GLOBAL).new && mv $(RVM_GLOBAL){.new,}
	@echo "${bold}Enjoy !${normal}"

$(HOME)/.%: %
	$(call check_file,$@)
	ln -fs $(PWD)/$< $@

update:
	git pull

.PHONY: install update

vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	@mkdir -p "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo,view}; \
	$(vim) +q

update:
	@git pull --ff --ff-only; \
	$(vim) --cmd 'set nomore' -c 'call dein#clear_state() | call dein#update()' +q
upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

test:
ifeq ('$(vim)','nvim')
	$(info Testing NVIM...)
	$(if $(findstring NVIM,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Is Neovim available in PATH?))
else
	$(info Testing VIM 7.4...)
	$(if $(findstring 7.4,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install newer $nvim version))

	$(info Testing +lua... )
	$(if $(findstring +lua,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install $nvim with "+lua" enabled))

	$(info Testing +python... )
	$(if $(findstring +python,$(vim_version)),\
		$(info OK),\
		$(error .. MISSING! Install $nvim with "+python" enabled))
endif
	@echo All tests passed, hooray!


.PHONY: install update upgrade uninstall test default

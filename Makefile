.PHONY: install uninstall purge

PREFIX  ?= $(HOME)/.local
DESTDIR ?=

BINDIR     = $(DESTDIR)$(PREFIX)/bin
SHAREDIR   = $(DESTDIR)$(PREFIX)/share/pmux
CONFIG_ROOT = $(or $(XDG_CONFIG_HOME),$(HOME)/.config)/pmux
CHEAT_DIR   = $(CONFIG_ROOT)/cheat

install:
	install -Dm755 pmux       $(BINDIR)/pmux
	install -Dm755 pmux-run   $(BINDIR)/pmux-run
	install -Dm755 pmux-cheat $(BINDIR)/pmux-cheat
	install -Dm644 examples/config          $(SHAREDIR)/config.example
	install -Dm644 examples/cheat/languages $(SHAREDIR)/cheat/languages
	install -Dm644 examples/cheat/commands  $(SHAREDIR)/cheat/commands
	@if [ -z "$(DESTDIR)" ]; then \
		mkdir -p $(CONFIG_ROOT) $(CHEAT_DIR); \
		if [ ! -f $(CONFIG_ROOT)/config ]; then \
			cp examples/config $(CONFIG_ROOT)/config; \
			echo "Created: $(CONFIG_ROOT)/config"; \
		else \
			echo "Kept existing: $(CONFIG_ROOT)/config"; \
		fi; \
		if [ ! -f $(CHEAT_DIR)/languages ]; then \
			cp examples/cheat/languages $(CHEAT_DIR)/languages; \
			echo "Created: $(CHEAT_DIR)/languages"; \
		fi; \
		if [ ! -f $(CHEAT_DIR)/commands ]; then \
			cp examples/cheat/commands $(CHEAT_DIR)/commands; \
			echo "Created: $(CHEAT_DIR)/commands"; \
		fi; \
	fi
	@echo ""
	@echo "Installed to $(BINDIR)/"

uninstall:
	rm -f $(BINDIR)/pmux $(BINDIR)/pmux-run $(BINDIR)/pmux-cheat

purge: uninstall
	rm -f  $(CONFIG_ROOT)/config $(CHEAT_DIR)/languages $(CHEAT_DIR)/commands
	rmdir  $(CHEAT_DIR)  2>/dev/null || true
	rmdir  $(CONFIG_ROOT) 2>/dev/null || true

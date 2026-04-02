.PHONY: install install-user uninstall uninstall-user purge

PREFIX  ?= /usr/local
DESTDIR ?=

BINDIR   = $(DESTDIR)$(PREFIX)/bin
SHAREDIR = $(DESTDIR)$(PREFIX)/share/pmux

BIN_DIR_USER    = $(HOME)/.local/bin
CONFIG_ROOT     = $(or $(XDG_CONFIG_HOME),$(HOME)/.config)/pmux
CHEAT_DIR       = $(CONFIG_ROOT)/cheat

# System install — used by PKGBUILD / make install DESTDIR=... PREFIX=/usr
install:
	install -Dm755 pmux       $(BINDIR)/pmux
	install -Dm755 pmux-run   $(BINDIR)/pmux-run
	install -Dm755 pmux-cheat $(BINDIR)/pmux-cheat
	install -Dm644 examples/config          $(SHAREDIR)/config.example
	install -Dm644 examples/cheat/languages $(SHAREDIR)/cheat/languages
	install -Dm644 examples/cheat/commands  $(SHAREDIR)/cheat/commands

# User install — installs to ~/.local/bin and bootstraps ~/.config/pmux
install-user:
	mkdir -p $(BIN_DIR_USER) $(CONFIG_ROOT) $(CHEAT_DIR)
	install -m755 pmux       $(BIN_DIR_USER)/pmux
	install -m755 pmux-run   $(BIN_DIR_USER)/pmux-run
	install -m755 pmux-cheat $(BIN_DIR_USER)/pmux-cheat
	@if [ ! -f $(CONFIG_ROOT)/config ]; then \
		cp examples/config $(CONFIG_ROOT)/config; \
		echo "Created: $(CONFIG_ROOT)/config"; \
	else \
		echo "Kept existing: $(CONFIG_ROOT)/config"; \
	fi
	@if [ ! -f $(CHEAT_DIR)/languages ]; then \
		cp examples/cheat/languages $(CHEAT_DIR)/languages; \
		echo "Created: $(CHEAT_DIR)/languages"; \
	fi
	@if [ ! -f $(CHEAT_DIR)/commands ]; then \
		cp examples/cheat/commands $(CHEAT_DIR)/commands; \
		echo "Created: $(CHEAT_DIR)/commands"; \
	fi
	@echo ""
	@echo "Installed to $(BIN_DIR_USER)/"

uninstall:
	rm -f $(BINDIR)/pmux $(BINDIR)/pmux-run $(BINDIR)/pmux-cheat

uninstall-user:
	rm -f $(BIN_DIR_USER)/pmux $(BIN_DIR_USER)/pmux-run $(BIN_DIR_USER)/pmux-cheat
	@echo "Kept config at $(CONFIG_ROOT)"

purge: uninstall-user
	rm -f  $(CONFIG_ROOT)/config $(CHEAT_DIR)/languages $(CHEAT_DIR)/commands
	rmdir  $(CHEAT_DIR)  2>/dev/null || true
	rmdir  $(CONFIG_ROOT) 2>/dev/null || true

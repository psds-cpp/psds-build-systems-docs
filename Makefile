ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := build
VPATH := $(BUILD_DIR)

TEX_SOURCES := $(wildcard presentations/*.tex)
PDF_TARGETS := $(patsubst presentations/%.tex,%.pdf,$(TEX_SOURCES))

.PHONY: \
	all \
	build \
	clean \
	help \
	install

all: build

build: 01-gnu-make.pdf

install: build
	mkdir -p "$(PREFIX)/presentations"
	cp "$(BUILD_DIR)/01-gnu-make.pdf" "$(PREFIX)/presentations/01-gnu-make.pdf"
	$(if $(PDF_TARGETS),cp $(addprefix $(BUILD_DIR)/,$(PDF_TARGETS)) "$(PREFIX)/presentations/")

clean:
	@if [ -d $(BUILD_DIR) ]; then \
		find $(BUILD_DIR) -mindepth 1 -maxdepth 1 ! -name drafts -exec rm -rf {} +; \
	fi

help:
	@printf "all\tbuild all presentations and homeworks\n"
	@printf "build\tbuild all presentations and homeworks\n"
	@printf "01-gnu-make.pdf\tbuild presentation 01-gnu-make.pdf\n"
	@printf "clean\tremove build artifacts\n"
	@printf "help\tprint this message\n"
	@printf "install\tinstall all presentations and homeworks\n"

define generate_pdf
	TEXINPUTS='$(shell pwd)//:' \
	SOURCE_DATE_EPOCH='$(shell date +%s)' \
	latexmk \
		-lualatex \
		-jobname=$(subst .pdf,,$2) \
		$1
endef

%.pdf: presentations/%.tex \
	presentations/presentationtemplate.sty \
	presentations/images/binary-file.png \
	presentations/images/source_code.png \
	presentations/images/prosoft-logo.png \
	packages/terminal.sty \
	packages/mylisting.sty
	$(call generate_pdf,$<,$@)

01-gnu-make.pdf: \
	presentations/01-gnu-make/01-gnu-make.tex \
	presentations/presentationtemplate.sty \
	presentations/images/binary-file.png \
	presentations/images/source_code.png \
	presentations/images/prosoft-logo.png \
	packages/terminal.sty \
	packages/mylisting.sty \
	$(wildcard presentations/01-gnu-make/src/*) \
	$(wildcard presentations/01-gnu-make/src/lib/*)
	$(call generate_pdf,$<,$@)

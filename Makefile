ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := build

.PHONY: \
	all \
	build \
	clean \
	help

all: build

build:

install: build
	mkdir -p "$(PREFIX)/presentations"

clean:
	rm -rf $(BUILD_DIR)

help:
	@printf "all\tbuild all presentations and homeworks\n"
	@printf "build\tbuild all presentations and homeworks\n"
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

*.pdf: \
	presentations/presentationtemplate.sty \
	presentations/images/binary-file.png \
	presentations/images/source_code.png \
	presentations/images/prosoft-logo.png \
	packages/terminal.sty \
	packages/mylisting.sty
	$(call generate_pdf,$<,$@)

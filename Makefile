
DOCS := hello

SRC_DIR := src
BUILD_DIR := build

# ENV := LANG=C.utf8
ASCIIDOCTOR_PDF := $(ENV) asciidoctor-pdf
ASCIIDOCTOR_HTML := $(ENV) asciidoctor
ASCIIDOCTOR_EPUB := $(ENV) asciidoctor-epub3

COMMON_OPTS := --trace \
								-a compress \
								-a mathematical-format=svg \
								-a pdf-fontsdir=fonts \
								-D build \
								--failure-level=ERROR
# REQUIRES := --require=asciidoctor-bibtex \
#             --require=asciidoctor-diagram \
#             --require=asciidoctor-lists
#             # --require=asciidoctor-mathematical

DOCS_PDF := $(addprefix $(BUILD_DIR)/, $(addsuffix .pdf, $(DOCS)))
DOCS_HTML := $(addprefix $(BUILD_DIR)/, $(addsuffix .html, $(DOCS)))
DOCS_EPUB := $(addprefix $(BUILD_DIR)/, $(addsuffix .epub, $(DOCS)))

.PHONY: build-docs
build-docs: 

.PHONY: build-pdf
build-pdf: $(DOCS_PDF)

.PHONY: build-html
build-html: $(DOCS_HTML)

.PHONY: build-epub
build-epub: $(DOCS_EPUB)

ALL_SRCS := $(shell git ls-files $(SRC_DIR))

$(BUILD_DIR)/%.pdf: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	mkdir -p $(BUILD_DIR)
	$(ASCIIDOCTOR_PDF) $(COMMON_OPTS) $(REQUIRES) $<

$(BUILD_DIR)/%.html: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	mkdir -p $(BUILD_DIR)
	$(ASCIIDOCTOR_HTML) $(COMMON_OPTS) $(REQUIRES) $<

$(BUILD_DIR)/%.epub: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	mkdir -p $(BUILD_DIR)
	$(ASCIIDOCTOR_EPUB) $(COMMON_OPTS) $(REQUIRES) $<

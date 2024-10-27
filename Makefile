
SRC_DIR := src/
DST_DIR := build/

OPTIONS := --doctype=book \
					--trace \
					--warnings \
					--failure-level=ERROR \
					--attribute toc \
					--attribute sectnums \
					--attribute sectlinks \
					--attribute sectanchors \
					--attribute compress \
					--attribute mathematical-format=svg \
					--attribute pdf-fontsdir=fonts
REQUIRES := --require=asciidoctor-diagram \
            --require=asciidoctor-lists \
            --require=asciidoctor-mathematical

DOCS_ADOC := $(shell find $(SRC_DIR) -type f -name *.adoc)

SRC_DIRS := $(shell find $(SRC_DIR) -type d -not -path $(SRC_DIR))
TGT_DIRS := $(subst $(SRC_DIR),,$(SRC_DIRS))
TGT_ALL := $(addsuffix /%.all, $(TGT_DIRS))
TGT_PDF := $(addsuffix /%.pdf, $(TGT_DIRS))
TGT_HTML := $(addsuffix /%.html, $(TGT_DIRS))
TGT_EPUB := $(addsuffix /%.epub, $(TGT_DIRS))

.PHONY: $(TGT_ALL)
$(TGT_ALL):
	$(MAKE) $(@D)/$(*F).pdf
	$(MAKE) $(@D)/$(*F).html
	$(MAKE) $(@D)/$(*F).epub

.PHONY: $(TGT_PDF) $(TGT_HTML) $(TGT_EPUB)
$(TGT_PDF) $(TGT_HTML) $(TGT_EPUB): 
	$(MAKE) $(DST_DIR)$@

$(DST_DIR)%.pdf: $(SRC_DIR)%.adoc $(DOCS_ADOC)
	mkdir -p $(@D)
	cp -r $(<D)/images $(@D)
	asciidoctor-pdf $(OPTIONS) $(REQUIRES) --destination-dir $(@D) $<

$(DST_DIR)%.html: $(SRC_DIR)%.adoc $(DOCS_ADOC)
	mkdir -p $(@D)
	cp -r $(<D)/images $(@D)
	asciidoctor $(OPTIONS) $(REQUIRES) --destination-dir $(@D) $<

$(DST_DIR)%.epub: $(SRC_DIR)%.adoc $(DOCS_ADOC)
	mkdir -p $(@D)
	cp -r $(<D)/images $(@D)
	asciidoctor-epub3 $(OPTIONS) $(REQUIRES) --destination-dir $(@D) $<

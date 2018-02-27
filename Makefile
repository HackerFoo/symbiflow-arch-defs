# Include files
include make/inc/common.mk
include make/inc/files.mk
# Generated files
include make/gen.mk
# Dependency generation
include make/deps.mk

# ------------------------------------------

# XML merging
MERGE_XML_INPUTS  = $(call find_nontemplate_files,*.xml)
MERGE_XML_OUTPUTS = $(foreach F,$(MERGE_XML_INPUTS),$(dir $(F))$(basename $(notdir $(F))).merged.xml)
MERGE_XML_XSL     := $(abspath $(TOP_DIR)/common/xml/xmlsort.xsl)
MERGE_XML_ARGS    := --nomkdir --nonet --xinclude

$(MERGE_XML_OUTPUTS): %.merged.xml: $(call depend_on_all,%.xml)
	xsltproc $(MERGE_XML_ARGS) --output $(TARGET) $(MERGE_XML_XSL) $(PREREQ_FIRST)

# Make sure the directory already exists
$(MERGE_XML_OUTPUTS): %.merged.xml: $(MERGE_XML_XSL)
# Depend on this Makefile (and it's deps)
#$(MERGE_XML_OUTPUTS): %.merged.xml: $(call ALL,$(INC_MAKEFILE))

# ------------------------------------------

all: $(MERGE_XML_OUTPUTS)
	@echo "----"
	@echo " MERGE_XML_OUTPUT output files"
	@echo "$(MERGE_XML_OUTPUTS)" | sed -e's/ /\n/g'

.PHONY: all
.DEFAULT_GOAL := all

clean:
	@rm -vf $(FILES_GENERATED)
	@find -name *.d -delete -print

.PHONY: clean

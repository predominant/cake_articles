# Makefile for handling the building of the articles

PYTHON = python

.PHONY: all clean html website

LANGS = en ja
DEST = website

# Dependencies to perform before running other builds.
# Clone the en/Makefile everywhere.
SPHINX_DEPENDENCIES = $(foreach lang, $(LANGS), $(lang)/Makefile)

# Copy-paste the english Makefile everwhere its needed.
%/Makefile: en/Makefile
	cp $< $@

# The various formats the documentation can be created in.
# Loop over the possible languages and call other build targets.
html: $(foreach lang, $(LANGS), html-$(lang))
#htmlhelp: $(foreach lang, $(LANGS), htmlhelp-$(lang))
#epub: $(foreach lang, $(LANGS), epub-$(lang))
#htmlhelp: $(foreach lang, $(LANGS), htmlhelp-$(lang))
#populate-index: $(foreach lang, $(LANGS), populate-index-$(lang))

# Make the HTML version of the documentation with correctly nested language folders.
html-%: $(SPHINX_DEPENDENCIES)
	cd $* && make html LANG=$*

website-dirs:
	# Make the directory if its not there already.
	[ ! -d $(DEST) ] && mkdir $(DEST) || true

	# Make the downloads directory
	[ ! -d $(DEST)/_downloads ] && mkdir $(DEST)/_downloads || true

	# Make downloads for each language
	$(foreach lang, $(LANGS), [ ! -d $(DEST)/_downloads/$(lang) ] && mkdir $(DEST)/_downloads/$(lang) || true;)

website: website-dirs html populate-index epub
	# Move HTML
	$(foreach lang, $(LANGS), cp -r build/html/$(lang) $(DEST)/$(lang);)

	# Move EPUB files
	$(foreach lang, $(LANGS), cp -r build/epub/$(lang)/*.epub $(DEST)/_downloads/$(lang);)

clean:
	rm -rf build/*

clean-website:
	rm -rf $(DEST)/*

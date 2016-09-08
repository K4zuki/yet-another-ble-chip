include Makefile.in

MDDIR:= markdown
DATADIR:= data
TARGETDIR:= Out

INPUT:= TITLE.md
TARGET = YetAnotherBLE
OUTPUT:= $(shell basename $(TARGET) .md)
CSV:= $(shell cd $(DATADIR); ls *.csv)
TABLES:= $(CSV:%.csv=$(TARGETDIR)/%.tmd)
FILTERED= $(INPUT:%.md=$(TARGETDIR)/%.fmd)
HTML:=$(TARGETDIR)/$(TARGET).html
DOCX:=$(TARGETDIR)/$(TARGET).docx
PDF:=	$(TARGETDIR)/$(TARGET).pdf

PANFLAGS += --toc
PANFLAGS += --listings
PANFLAGS += --number-sections --highlight-style=pygments
PANFLAGS += -M localfontdir=$(FONTDIR)

.PHONY: docx merge filtered tables tex pdf clean

all: pdf

html: $(HTML)

$(HTML): $(TABLES) $(FILTERED)
	$(PANDOC) $(PANFLAGS) --self-contained -thtml5 --template=$(MISC)/github.html \
		$(FILTERED) -o $(HTML)

pdf: tex
	xelatex --output-directory=$(TARGETDIR) --no-pdf $(TARGETDIR)/$(TARGET).tex; \
	cd $(TARGETDIR); \
	rm -f ./images; \
	ln -s ../images; \
	xelatex $(TARGET).tex

tex: merge
	$(PANDOC) $(PANFLAGS) --template=$(MISC)/CJK_xelatex.tex --latex-engine=xelatex \
		$(TARGETDIR)/$(TARGET).md -o $(TARGETDIR)/$(TARGET).tex

merge: filtered
	cat $(FILTERED) > $(TARGETDIR)/$(TARGET).md

filtered: tables $(FILTERED)
$(FILTERED): $(MDDIR)/$(INPUT)
	cat $< | $(PYTHON) $(FILTER) --mode tex --out $@

tables: $(TABLES)
$(TARGETDIR)/%.tmd: $(DATADIR)/%.csv
	$(PYTHON) $(CSV2TABLE) --file $< --out $@ --delimiter ','

mkdir:
	mkdir -p $(TARGETDIR)
	mkdir -p $(DATADIR)
	mkdir -p $(MDDIR)

clean: mkdir
	# rm images/*_r????.png
	rm -rf $(TARGETDIR)
	mkdir -p $(TARGETDIR)

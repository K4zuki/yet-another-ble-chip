BUSYBOX=
LS = ls
SH = bash
BASENAME = basename
# if [ $(OSTYPE) -eq "msys"] ;then
# HOME = "C:/Users/$(USERNAME)"
# endif

ifeq ($(OS),Windows_NT)
		HOME = C:/Users/$(USERNAME)
		CABAL = /c/Users/Kazuki/AppData/Roaming/cabal/
		PCROSSREF = $(CABAL)/bin/pandoc-crossref.exe
else
		CABAL = $(HOME)/.cabal
		PCROSSREF = $(CABAL)/bin/pandoc-crossref
endif

PANSTYLES = $(HOME)/.pandoc
MISC = $(PANSTYLES)/pandoc_misc
REF_DOCX = $(MISC)/ref.docx
PYTHON = python

PANDOC = pandoc
PFLAGS = -s -S
PFLAGS += --read=markdown+east_asian_line_breaks
# +implicit_figures
# +inline_code_attributes
# +header_attributes
# +escaped_line_breaks

PFLAGS += --toc
PFLAGS += --listings
# PFLAGS += --filter $(CABAL)/bin/pandoc-crossref
PFLAGS += --filter $(PCROSSREF)
PFLAGS += --smart --standalone --number-sections --highlight-style=pygments
PFLAGS += --reference-docx=$(REF_DOCX)

MDSRC =  README.md
# MDSRC += $(shell $(LS) 0.[234]*.md)
# MDSRC += $(shell $(LS) 1.[01]*.md)
# MDSRC += $(shell $(LS) 2.[0]*.md)
# #MDSRC += $(shell $(LS) 2.[0]*.md)
# MDSRC += $(shell $(LS) 3.[01]*.md)
# MDSRC += $(shell $(LS) 4.[01]*.md)
# MDSRC += $(shell $(LS) 9.9*.md)

# CSV2TABLE:= csv2mdtable.py
# FILTER:= include.py
CSV2TABLE := $(MISC)/csv2mdtable.py
FILTER := $(MISC)/include.py

# all md source files but fith f_ prefix
SRC = $(filter-out f_%.md,$(MDSRC))

OUT = ./Out
# all f_*.md files
FILTERED= $(addprefix $(OUT)/f_,$(SRC))
# FILTERED := $(SRC:%=f_%)

CSV := $(shell $(LS) *.csv)
TABLES := $(addprefix $(OUT)/,$(CSV:.csv=_t.md))
# TABLES := $(CSV:.csv=_t.md)

TARGET = YetAnotherBLE

.PHONY: docx merge filtered tables tex pdf clean
all: pdf

html: merge
	$(PANDOC) $(PFLAGS) --template=$(MISC)/github.html -thtml5 $(FILTERED) -o $(OUT)/$(TARGET).html

pdf: tex
	xelatex --output-directory=$(OUT) --no-pdf $(OUT)/$(TARGET).tex; \
	cd $(OUT); \
	rm -f ./images; \
	ln -s ../images ./images; \
	xelatex $(TARGET).tex

tex: merge
	$(PANDOC) $(PFLAGS) --template=$(MISC)/CJK_xelatex.tex --latex-engine=xelatex $(OUT)/$(TARGET).md -o $(OUT)/$(TARGET).tex

merge: filtered
	$(BUSYBOX) cat $(FILTERED) > $(OUT)/$(TARGET).md

filtered: tables
	for src in $(SRC);do \
		echo $$src; \
		$(BUSYBOX) cat $$src | $(PYTHON) $(FILTER) --mode tex --out $(OUT)/f_$$src \
	;done

tables: $(CSV) mkdir
	echo $(HOME)
	echo $(CABAL)
	for csv in $(CSV);do \
		echo $$csv; \
		$(PYTHON) $(CSV2TABLE) --file $$csv \
			--out $(OUT)/`$(BASENAME) $$csv .csv`_b.md --delimiter \;; \
		$(PYTHON) $(CSV2TABLE) --file $$csv \
			--out $(OUT)/`$(BASENAME) $$csv .csv`_t.md --delimiter "," \
	;done

mkdir:
	mkdir -p $(OUT)

clean:
	rm -rf $(OUT)/*
#	ls $(TABLES); if [ $$? -eq 0 ] ;then rm $(TABLES) ;fi
#	ls $(FILTERED); if [ $$? -eq 0 ] ;then rm $(FILTERED) ;fi
#	ls *_t.md; if [ $$? -eq 0 ] ;then rm *_t.md ;fi
#	ls f_*.md; if [ $$? -eq 0 ] ;then rm f_*.md ;fi
	if [ -f $(TARGET).tex ] ;then $(BUSYBOX) rm $(TARGET).tex ;fi
	if [ -f $(TARGET).out ] ;then $(BUSYBOX) rm $(TARGET).out ;fi
	if [ -f $(TARGET).aux ] ;then $(BUSYBOX) rm $(TARGET).aux ;fi
	if [ -f $(TARGET).log ] ;then $(BUSYBOX) rm $(TARGET).log ;fi
	if [ -f $(TARGET).toc ] ;then $(BUSYBOX) rm $(TARGET).toc ;fi
	if [ -f $(TARGET).md  ] ;then $(BUSYBOX) rm $(TARGET).md  ;fi
	if [ -f $(TARGET).xdv ] ;then $(BUSYBOX) rm $(TARGET).xdv ;fi

BUSYBOX=
LS = ls
SH = bash
BASENAME = basename
PANDOC = pandoc

PANSTYLES = $(HOME)/.pandoc
MISC = $(PANSTYLES)/pandoc_misc
REF_DOCX = $(MISC)/ref.docx
CABAL = $(HOME)/.cabal


PYTHON= python
PFLAGS = -s -S
PFLAGS += --read=markdown+east_asian_line_breaks+header_attributes+escaped_line_breaks+implicit_figures
PFLAGS += --toc --list
PFLAGS += --filter $(CABAL)/bin/pandoc-crossref
#PFLAGS += --filter $(CABAL)/bin/pandoc-include
PFLAGS += --smart --standalone --number-sections --highlight-style=pygments
PFLAGS += --reference-docx=$(REF_DOCX)

MDSRC =  README.md
MDSRC += $(shell $(LS) 0.[234]*.md)
MDSRC += $(shell $(LS) 1.[01]*.md)
#MDSRC += $(shell $(LS) 2.[0123]*.md)
MDSRC += $(shell $(LS) 2.[0]*.md)
MDSRC += $(shell $(LS) 3.[01]*.md)
MDSRC += $(shell $(LS) 4.[01]*.md)
MDSRC += $(shell $(LS) 9.9*.md)

#CSV2TABLE:= csv2mdtable.py
#FILTER:= include.py
CSV2TABLE:= $(MISC)/csv2mdtable.py
FILTER:= $(MISC)/include.py

#all md source files but fith f_ prefix
SRC= $(filter-out f_%.md,$(MDSRC))

# all f_*.md files
FILTERED:= $(SRC:%=f_%)
#FILTERED= $(addprefix f_,$(SRC))

CSV:= $(shell $(LS) *.csv)
TABLES:= $(CSV:.csv=_t.md)

TARGET = YetAnotherBLE

all: docx pdf

docx: merge
	$(PANDOC) $(PFLAGS) $(FILTERED) -o $(TARGET).docx

merge: filtered
	$(BUSYBOX) cat $(FILTERED) > $(TARGET).md

#$(FILTERED): $(TABLES)
filtered: tables
	for src in $(SRC);do\
		$(BUSYBOX) cat $$src | $(PYTHON) $(FILTER)  --out f_$$src \
	;done

#	$(ECHO) $(CSV) $(TABLES) $(PYTHON) $(CSV2TABLE) $^

#$(SRC): $(TABLES)

#$(TABLES): $(CSV)
tables: $(CSV)
	for csv in $(CSV);do\
		$(PYTHON) $(CSV2TABLE) --file $$csv --out `$(BASENAME) $$csv .csv`_t.md --delimiter ',' \
	;done
#		$(BUSYBOX) cat $$src | $(PYTHON) $(FILTER)  --out f_$$src \

tex: merge
	$(PANDOC) $(PFLAGS) --template=$(MISC)/CJK_xelatex.tex --latex-engine=xelatex $(TARGET).md -o $(TARGET).tex
#	$(PANDOC) $(PFLAGS) --template=$(PANSTYLES)/CJK_xelatex.tex --latex-engine=xelatex $(MDSRC) -o $(TARGET).tex

pdf: tex
	xelatex --no-pdf $(TARGET).tex ;xelatex $(TARGET).tex

.PHONY: clean
clean:
	ls $(TABLES); if [ $$? -eq 0 ] ;then rm $(TABLES) ;fi
	ls $(FILTERED); if [ $$? -eq 0 ] ;then rm $(FILTERED) ;fi
	ls *_t.md; if [ $$? -eq 0 ] ;then rm *_t.md ;fi
	ls f_*.md; if [ $$? -eq 0 ] ;then rm f_*.md ;fi
	if [ -f $(TARGET).tex ] ;then $(BUSYBOX) rm $(TARGET).tex ;fi
	if [ -f $(TARGET).out ] ;then $(BUSYBOX) rm $(TARGET).out ;fi
	if [ -f $(TARGET).aux ] ;then $(BUSYBOX) rm $(TARGET).aux ;fi
	if [ -f $(TARGET).log ] ;then $(BUSYBOX) rm $(TARGET).log ;fi
	if [ -f $(TARGET).toc ] ;then $(BUSYBOX) rm $(TARGET).toc ;fi
	if [ -f $(TARGET).md  ] ;then $(BUSYBOX) rm $(TARGET).md  ;fi
	if [ -f $(TARGET).xdv ] ;then $(BUSYBOX) rm $(TARGET).xdv ;fi

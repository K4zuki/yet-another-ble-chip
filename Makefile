WINDOWS =
ifdef WINDOWS
#windows
SHELL=C://busybox.exe sh -c
BUSYBOX=C://busybox.exe
LS =  ls
SH = $(BUSYBOX) sh -c
BASENAME = $(BUSYBOX) basename
PANDOC = C:/Users/kyamamot/AppData/Local/Pandoc/pandoc
HOME=C:/SPB_Data
else
#linux
BUSYBOX=
LS = ls
SH = bash
BASENAME = basename
PANDOC = pandoc
endif

PANSTYLES = $(HOME)/.pandoc
REF_DOCX = $(PANSTYLES)/ref.docx

PYTHON= python
PFLAGS = -s -S
PFLAGS += --read=markdown+ignore_line_breaks+header_attributes+escaped_line_breaks+implicit_figures
PFLAGS += --toc --list
PFLAGS += --smart --standalone --number-sections --highlight-style=pygments
PFLAGS += --reference-docx=$(REF_DOCX)

MDSRC =  README.md
MDSRC += $(shell $(LS) 0.[234]*.md)
MDSRC += $(shell $(LS) 1.[01]*.md)
MDSRC += $(shell $(LS) 2.[0123]*.md)
MDSRC += $(shell $(LS) 3.[01]*.md)
MDSRC += $(shell $(LS) 4.[01]*.md)
MDSRC += $(shell $(LS) 9.9*.md)

CSV2TABLE:= csv2mdtable.py
FILTER:= include.py

SRC=$(filter-out f_%.md,$(MDSRC))
FILTERED=$(addprefix f_,$(SRC))
#FILTERED:= $(INPUT:.md=f_%.md)
CSV:= $(shell $(LS) *.csv)
TABLES:= $(CSV:.csv=_t.md)

TARGET = YetAnotherBLE

all: docx pdf

docx: merge
	$(PANDOC) $(PFLAGS) $(FILTERED) -o $(TARGET).docx

merge: $(FILTERED)
	$(BUSYBOX) cat $(FILTERED) > $(TARGET).md

#filtered: tables $(FILTERED)

#tables: $(TABLES)

$(FILTERED): $(SRC) $(TABLES)
	$(BUSYBOX) cat $< | $(PYTHON) $(FILTER)  --out $@
#	$(ECHO) $(CSV) $(TABLES) $(PYTHON) $(CSV2TABLE) $^

$(TABLES): $(CSV)
	$(PYTHON) $(CSV2TABLE) --file $< --out $@ --delimiter ','

tex: merge
	$(PANDOC) $(PFLAGS) --template=$(PANSTYLES)/CJK_xelatex.tex --latex-engine=xelatex $(TARGET).md -o $(TARGET).tex
#	$(PANDOC) $(PFLAGS) --template=$(PANSTYLES)/CJK_xelatex.tex --latex-engine=xelatex $(MDSRC) -o $(TARGET).tex

pdf: tex
	xelatex --no-pdf $(TARGET).tex ;xelatex $(TARGET).tex
	make clean

.PHONY: clean
clean:
	ls $(TABLES); if [ "$$?" == 0 ] ;then rm $(TABLES) ;fi
	ls $(FILTERED); if [ "$$?" == 0 ] ;then rm $(FILTERED) ;fi
	ls *_t.md; if [ "$$?" == 0 ] ;then rm *_t.md ;fi
	ls f_*.md; if [ "$$?" == 0 ] ;then rm f_*.md ;fi
	if [ -f $(TARGET).tex ] ;then $(BUSYBOX) rm $(TARGET).tex ;fi
	if [ -f $(TARGET).out ] ;then $(BUSYBOX) rm $(TARGET).out ;fi
	if [ -f $(TARGET).aux ] ;then $(BUSYBOX) rm $(TARGET).aux ;fi
	if [ -f $(TARGET).log ] ;then $(BUSYBOX) rm $(TARGET).log ;fi
	if [ -f $(TARGET).toc ] ;then $(BUSYBOX) rm $(TARGET).toc ;fi
	if [ -f $(TARGET).md  ] ;then $(BUSYBOX) rm $(TARGET).md  ;fi

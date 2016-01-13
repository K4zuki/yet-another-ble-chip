WINDOWS =
ifdef WINDOWS
#windows
LS = C://busybox ls
SH = C://busybox sh -c
BASENAME = C://busybox basename
PANDOC = C:/Users/yamamoto/AppData/Local/Pandoc/pandoc
HOME=
else
#linux
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
MDSRC = $(shell ls README.md)
MDSRC += $(shell ls 0.[234]*.md)
MDSRC += $(shell ls 1.[01]*.md)
MDSRC += $(shell ls 2.[0123]*.md)
MDSRC += $(shell ls 3.[01]*.md)
MDSRC += $(shell ls 4.[01]*.md)
MDSRC += $(shell ls 9.9*.md)
#SRC=$(shell ls $(MDSRC))
FILTERED:= $(MDSRC:.md=_f.md)
TARGET = YetAnotherBLE

all: docx pdf

docx:
	$(PANDOC) $(PFLAGS) $(MDSRC) -o $(TARGET).docx

tables: $(FILTERED)

%_f.md: %.md
	cat $< | $(PYTHON) ./include.py --out $@

merge: tables
	cat $(FILTERED) > $(TARGET).md

tex: merge
	$(PANDOC) $(PFLAGS) --template=$(PANSTYLES)/CJK_xelatex.tex --latex-engine=xelatex $(TARGET).md -o $(TARGET).tex
#	$(PANDOC) $(PFLAGS) --template=$(PANSTYLES)/CJK_xelatex.tex --latex-engine=xelatex $(MDSRC) -o $(TARGET).tex

pdf: tex
	xelatex --no-pdf $(TARGET).tex ;xelatex $(TARGET).tex
	make clean

clean:
	if [ -f $(TARGET).tex ] ;then rm $(TARGET).tex ;fi
	if [ -f $(TARGET).out ] ;then rm $(TARGET).out ;fi
	if [ -f $(TARGET).aux ] ;then rm $(TARGET).aux ;fi
	if [ -f $(TARGET).log ] ;then rm $(TARGET).log ;fi
	if [ -f $(TARGET).toc ] ;then rm $(TARGET).toc ;fi
	if [ -f $(TARGET).md  ] ;then rm $(TARGET).md  ;fi
	rm *_f.md

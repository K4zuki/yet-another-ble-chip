PANDOC = pandoc
#HOME = /home/yamamoto
REF_DOCX = $(HOME)/.pandoc/ref.docx
PFLAGS = -s -S
PFLAGS += --read=markdown+ignore_line_breaks+header_attributes+escaped_line_breaks+implicit_figures
PFLAGS += --toc
PFLAGS += --smart --standalone --number-sections --highlight-style=pygments
PFLAGS += --reference-docx=$(REF_DOCX)
MDSRC = README.md
MDSRC += 0.[234]*.md
MDSRC += 1.[01]*.md
MDSRC += 2.[0123]*.md
MDSRC += 3.[01]*.md
MDSRC += 4.[01]*.md
TARGET = YetAnotherBLE.docx

all: docx
#	ls $(MDSRC)
#	$(PANDOC) $(PFLAGS) $(MDSRC) -o $(TARGET)

docx:
	$(PANDOC) $(PFLAGS) $(MDSRC) -o $(TARGET)

#md -> tex -> docx

#pandoc -s -S README.md 0.[234]*.md 1.*.md 2.[01234]*.md 3.[0123]*.md --read=markdown+ignore_line_breaks+strikeout --reference-docx=$HOME/Dropbox/ref.docx --toc -o $HOME/Dropbox/out.docx

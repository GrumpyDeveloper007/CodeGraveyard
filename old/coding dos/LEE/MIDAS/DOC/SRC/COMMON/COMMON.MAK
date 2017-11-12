DESTDIR = ../html/$(DOCNAME)
LATEX2HTMLDIR = /home/pekangas/latex2html-96.1
LATEX2HTML = $(LATEX2HTMLDIR)/latex2html
LATEX2HTMLOPTS = -init_file ../common/latex2html-init -dir $(DESTDIR)
LATEX = latex
RM = rm
RMDIR = rmdir

export TEXINPUTS := ../common:$(LATEX2HTMLDIR)/texinputs:$(TEXINPUTS)

.PRECIOUS:	%.aux %.toc

%-html :	%.aux %.toc
		$(LATEX2HTML) $(LATEX2HTMLOPTS) $*
		echo done > $@

%.dvi :		%.aux %.toc
		$(LATEX) $*

%.aux %.toc :	%.tex $(DOCINCLUDES)
		$(LATEX) $*
		$(RM) $*.dvi

clean :
		-$(RM) $(DESTDIR)/*
		-$(RM) $(DESTDIR)/.*
		-$(RMDIR) $(DESTDIR)
		-$(RM) *.log *.toc *.aux *.dvi *~
		-$(RM) *-html
		-$(RM) core









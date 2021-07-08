mkdir -p $PWD/.temp

FILENAME=$PWD'/main.tex'



pdflatex $FILENAME
base=$(basename $FILENAME .tex)
echo $base
bibtex $base
pdflatex $FILENAME
pdflatex $FILENAME

mv -f *.aux *.bbl *.blg *.log *.toc *.soc *.loc *.out .temp/

xdg-open $PWD/main.pdf

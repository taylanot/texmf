mkdir -p $PWD/.temp

FILENAME=$PWD'/main.tex'


if [ "$#" -eq  "0" ]
  then
    pdflatex $FILENAME
else

    pdflatex -jobname $1 $FILENAME
fi
base=$(basename $FILENAME .tex)
echo $base
bibtex $base
pdflatex $FILENAME
pdflatex $FILENAME

mv -f *.aux *.bbl *.blg *.log *.toc *.soc *.loc *.out *.nav *.snm *.xml *.bib .temp/

#xdg-open $PWD/main.pdf

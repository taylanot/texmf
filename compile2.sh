mkdir -p $PWD/.temp

FILENAME=$PWD'/main.tex'


if [ "$#" -eq  "0" ]
  then
    pdflatex -shell-escape  $FILENAME 
else

    pdflatex -shell-escape -jobname $1 $FILENAME 
fi
base=$(basename $FILENAME .tex)
echo $base
pdflatex $FILENAME
biber $base
pdflatex $FILENAME

mv -f *.aux *.auxlock *.bcf *.bbl *.blg *.log *.toc *.soc *.loc *.out *.nav *.snm *.xml *.bib *.abs .temp/

#xdg-open $PWD/main.pdf

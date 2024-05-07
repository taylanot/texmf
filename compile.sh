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
bibtex $base
pdflatex $FILENAME
pdflatex $FILENAME

mv -f *.aux *.auxlock *.bbl *.blg *.log *.toc *.soc *.loc *.out *.nav *.snm *.xml *.abs *.spl .temp/

#xdg-open $PWD/main.pdf

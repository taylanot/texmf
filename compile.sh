mkdir -p "$PWD/.temp"

# Set default filename if no argument is provided
FILENAME=${1:-"$PWD/main.tex"}
JOBNAME=$(basename "$FILENAME" .tex)

pdflatex -shell-escape -jobname "$JOBNAME" "$FILENAME"

bibtex "$JOBNAME"

pdflatex "$FILENAME"
pdflatex "$FILENAME"

mv -f *.aux *.auxlock *.bbl *.blg *.log *.toc *.soc *.loc *.out *.nav *.snm *.xml *.abs *.spl .temp/

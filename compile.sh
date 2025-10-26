# mkdir -p "$PWD/.temp"

# # Set default filename if no argument is provided
# FILENAME=${1:-"$PWD/main.tex"}
# JOBNAME=$(basename "$FILENAME" .tex)

# pdflatex -shell-escape -jobname "$JOBNAME" "$FILENAME"

# bibtex "$JOBNAME"

# pdflatex "$FILENAME"
# pdflatex "$FILENAME"

# mv -f *.aux *.auxlock *.bbl *.blg *.log *.toc *.soc *.loc *.out *.nav *.snm *.xml *.abs *.spl *.bcf .temp/



#!/usr/bin/env bash
# Compile a LaTeX file with pdflatex + bibtex and clean auxiliary files
# Usage:
#   ./compile_tex.sh [path/to/file.tex]
# Defaults to main.tex in the current directory.

set -eu

# --- Input file ---
FILENAME=${1:-"$PWD/main.tex"}
if [ ! -f "$FILENAME" ]; then
    echo "❌ File '$FILENAME' not found."
    exit 1
fi

BASENAME=$(basename "$FILENAME" .tex)

echo "📄 Compiling $FILENAME ..."
echo

# --- First pdflatex pass ---
pdflatex  -shell-escape -jobname "$BASENAME" "$FILENAME" 

# --- Bibtex ---
bibtex "$BASENAME"  || echo "⚠️ Bibtex failed or not needed."

# --- Subsequent pdflatex passes ---
pdflatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1
pdflatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1


echo "✅ Compilation successful. Cleaning up auxiliary files..."
# Remove all common aux/log files except .pdf
rm -f \
    "${BASENAME}.aux" \
    "${BASENAME}.auxlock" \
    "${BASENAME}.bbl" \
    "${BASENAME}.blg" \
    "${BASENAME}.toc" \
    "${BASENAME}.soc" \
    "${BASENAME}.loc" \
    "${BASENAME}.out" \
    "${BASENAME}.nav" \
    "${BASENAME}.snm" \
    "${BASENAME}.xml" \
    "${BASENAME}.abs" \
    "${BASENAME}.spl" \
    "${BASENAME}.bcf"

echo "🎉 Done! Output PDF: ${BASENAME}.pdf"


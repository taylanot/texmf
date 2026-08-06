#!/usr/bin/env bash
# Compile a LaTeX file with pdflatex + bibtex/biber and clean auxiliary files
# Usage:
#   ./compile_tex.sh [bibtex|biber] [path/to/file.tex]
# Defaults: bibtex + main.tex

set -eu

# --- Backend + input file detection ---
BIB_BACKEND="bibtex"

if [ "${1:-}" = "bibtex" ] || [ "${1:-}" = "biber" ]; then
    BIB_BACKEND="$1"
    FILENAME=${2:-"$PWD/main.tex"}
else
    FILENAME=${1:-"$PWD/main.tex"}
fi

if [ ! -f "$FILENAME" ]; then
    echo "❌ File '$FILENAME' not found."
    exit 1
fi

BASENAME=$(basename "$FILENAME" .tex)

echo "📄 Compiling $FILENAME using $BIB_BACKEND ..."
echo

# --- First pdflatex pass ---
xelatex -shell-escape -jobname "$BASENAME" "$FILENAME"

# --- Bibtex / Biber ---
if [ "$BIB_BACKEND" = "biber" ]; then
    biber "$BASENAME" || echo "⚠️ Biber failed or not needed."
else
    bibtex "$BASENAME" || echo "⚠️ Bibtex failed or not needed."
fi

# --- Subsequent pdflatex passes ---
xelatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1
xelatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1

echo "✅ Compilation successful. Cleaning up auxiliary files..."
rm -f \
    *.aux \
    *.log \
    *.auxlock \
    *.bbl \
    *.blg \
    *.toc \
    *.soc \
    *.loc \
    *.out \
    *.nav \
    *.snm \
    *.xml \
    *.abs \
    *.spl \
    *.bcf

echo "🎉 Done! Output PDF: ${BASENAME}.pdf"

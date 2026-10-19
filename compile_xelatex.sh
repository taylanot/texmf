#!/usr/bin/env bash
# Compile a LaTeX file with xelatex + bibtex/biber and clean auxiliary files
# Usage:
#   ./compile_xelatex.sh [bibtex|biber] [path/to/file.tex] [output_dir] [output_filename.pdf]
# Defaults: bibtex + main.tex + . + main.pdf

set -eu

# --- Backend + input file detection ---
BIB_BACKEND="bibtex"

if [ "${1:-}" = "bibtex" ] || [ "${1:-}" = "biber" ]; then
    BIB_BACKEND="$1"
    FILENAME=${2:-"$PWD/main.tex"}
    OUTPUT_DIR=${3:-"."}
    OUTPUT_PDF=${4:-"$(basename "$FILENAME" .tex).pdf"}
else
    FILENAME=${1:-"$PWD/main.tex"}
    OUTPUT_DIR=${2:-"."}
    OUTPUT_PDF=${3:-"$(basename "$FILENAME" .tex).pdf"}
fi

if [ ! -f "$FILENAME" ]; then
    echo "❌ File '$FILENAME' not found."
    exit 1
fi

BASENAME=$(basename "$FILENAME" .tex)
JOBNAME=$(basename "$OUTPUT_PDF" .pdf)

mkdir -p "$OUTPUT_DIR"

echo "📄 Compiling $FILENAME using $BIB_BACKEND ..."
echo "📁 Output directory: $OUTPUT_DIR"
echo "📄 Output PDF: ${JOBNAME}.pdf"
echo

# --- First xelatex pass ---
xelatex -shell-escape -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME"

# --- Bibtex / Biber ---
# Run from output dir so it finds auxiliary files
cd "$OUTPUT_DIR"
if [ "$BIB_BACKEND" = "biber" ]; then
    biber "$JOBNAME" || echo "⚠️ Biber failed or not needed."
else
    bibtex "$JOBNAME" || echo "⚠️ Bibtex failed or not needed."
fi
cd - > /dev/null

# --- Subsequent xelatex passes ---
xelatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1
xelatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1

echo "✅ Compilation successful. Cleaning up auxiliary files..."
cd "$OUTPUT_DIR"
rm -f \
    "${JOBNAME}.aux" \
    "${JOBNAME}.log" \
    "${JOBNAME}.auxlock" \
    "${JOBNAME}.bbl" \
    "${JOBNAME}.blg" \
    "${JOBNAME}.toc" \
    "${JOBNAME}.soc" \
    "${JOBNAME}.loc" \
    "${JOBNAME}.out" \
    "${JOBNAME}.nav" \
    "${JOBNAME}.snm" \
    "${JOBNAME}.xml" \
    "${JOBNAME}.abs" \
    "${JOBNAME}.spl" \
    "${JOBNAME}.bcf"
cd - > /dev/null

echo "🎉 Done! Output PDF: ${OUTPUT_DIR}/${JOBNAME}.pdf"

#!/usr/bin/env bash
set -eu

# --- Input file ---
FILENAME=${1:-"$PWD/main.tex"}
if [ ! -f "$FILENAME" ]; then
    echo "❌ File '$FILENAME' not found."
    exit 1
fi

BASENAME=$(basename "$FILENAME" .tex)

# --- Output directory and file ---
OUTPUT_DIR=${2:-"."}
mkdir -p "$OUTPUT_DIR"

OUTPUT_PDF=${3:-"${BASENAME}.pdf"}
JOBNAME=$(basename "$OUTPUT_PDF" .pdf)

echo "📄 Compiling $FILENAME ..."
echo "📁 Output directory: $OUTPUT_DIR"
echo "📄 Output PDF name: ${JOBNAME}.pdf"
echo

# --- First pdflatex pass ---
pdflatex -shell-escape -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" 

# --- Bibtex ---
cd "$OUTPUT_DIR"
biber "$JOBNAME" || echo "⚠️ Bibtex failed or not needed."
cd - > /dev/null

# --- Subsequent pdflatex passes ---
pdflatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1
pdflatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1


echo "✅ Compilation successful. Cleaning up auxiliary files..."
# Remove all common aux/log files except .pdf
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

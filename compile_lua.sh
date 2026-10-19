#!/usr/bin/env bash
set -eu

# Usage: ./compile_lua.sh [input_file.tex] [output_dir] [output_filename.pdf]
FILENAME=${1:-"$PWD/main.tex"}
if [ ! -f "$FILENAME" ]; then
    echo "❌ File '$FILENAME' not found."
    exit 1
fi

BASENAME=$(basename "$FILENAME" .tex)

OUTPUT_DIR=${2:-"."}
mkdir -p "$OUTPUT_DIR"

OUTPUT_PDF=${3:-"${BASENAME}.pdf"}
JOBNAME=$(basename "$OUTPUT_PDF" .pdf)

echo "📄 Compiling $FILENAME with lualatex ..."
echo "📁 Output directory: $OUTPUT_DIR"
echo "📄 Output PDF: ${JOBNAME}.pdf"
echo

lualatex -shell-escape -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME"

cd "$OUTPUT_DIR"
bibtex "$JOBNAME" || echo "⚠️ Bibtex failed or not needed."
cd - > /dev/null

lualatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1
lualatex -interaction=nonstopmode -output-directory="$OUTPUT_DIR" -jobname="$JOBNAME" "$FILENAME" > /dev/null 2>&1

echo "✅ Compilation successful. Cleaning up auxiliary files..."
cd "$OUTPUT_DIR"
mkdir -p .temp
mv -f \
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
    "${JOBNAME}.bcf" \
    .temp/ 2>/dev/null || true
cd - > /dev/null

echo "🎉 Done! Output PDF: ${OUTPUT_DIR}/${JOBNAME}.pdf"

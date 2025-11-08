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
biber "$BASENAME"  || echo "⚠️ Bibtex failed or not needed."

# --- Subsequent pdflatex passes ---
pdflatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1
pdflatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1


echo "✅ Compilation successful. Cleaning up auxiliary files..."
# Remove all common aux/log files except .pdf
rm -f \
    "${BASENAME}.aux" \
    "${BASENAME}.log" \
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


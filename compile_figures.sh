#!/usr/bin/env bash
# Compile all .tex files containing TikZ code into standalone PDFs.
# Usage:
#   ./compile_figures.sh [input_directory] [output_directory]
# Defaults to current directory for both if not specified.

# --- Directories ---
INPUT_DIR=${1:-"."}
OUTPUT_DIR=${2:-"$INPUT_DIR"}

# Resolve paths (realpath may not exist on all systems)
if command -v realpath >/dev/null 2>&1; then
    INPUT_DIR=$(realpath "$INPUT_DIR")
    OUTPUT_DIR=$(realpath -m "$OUTPUT_DIR")
fi

# Check input directory
if [ ! -d "$INPUT_DIR" ]; then
    echo "❌ Input directory '$INPUT_DIR' not found."
    exit 1
fi

# Create output directory if missing
mkdir -p "$OUTPUT_DIR"

echo "📁 Input directory:  $INPUT_DIR"
echo "📄 Output directory: $OUTPUT_DIR"
echo

# --- Main loop ---
found_any=false
for texfile in "$INPUT_DIR"/*.tex; do
    [ -e "$texfile" ] || continue
    found_any=true

    basename=$(basename "$texfile" .tex)
    tmpfile="${OUTPUT_DIR}/${basename}_standalone.tex"

    echo "🔧 Creating standalone file for $texfile..."

    # Create standalone wrapper
    cat > "$tmpfile" <<EOF
\\documentclass[tikz,border=2pt]{standalone}
\\usepackage{tikz}
\\usepackage{pgfplots}
\\pgfplotsset{compat=newest}
\\begin{document}
$(cat "$texfile")
\\end{document}
EOF

    # Compile quietly
    echo "🧩 Compiling $basename to PDF..."
    lualatex -interaction=nonstopmode -output-directory "$OUTPUT_DIR" "$tmpfile" > /dev/null 2>&1

    # Rename output to match original name
    if [ -f "${OUTPUT_DIR}/${basename}_standalone.pdf" ]; then
        mv "${OUTPUT_DIR}/${basename}_standalone.pdf" "${OUTPUT_DIR}/${basename}.pdf"
        echo "✅ Created ${OUTPUT_DIR}/${basename}.pdf"
    else
        echo "❌ Failed to compile ${basename}"
    fi

    # Clean up only the relevant files
    for ext in aux log tex; do
        rm -f "${OUTPUT_DIR}/${basename}_standalone.${ext}"
    done
done

if [ "$found_any" = false ]; then
    echo "⚠️  No .tex files found in '$INPUT_DIR'."
else
    echo
    echo "🎉 All TikZ plots compiled successfully!"
fi


#!/bin/bash

echo "========================================="
echo "   Astro CLI Project Configurator"
echo "========================================="
echo ""

# Assign arguments to meaningful variables
FILE_TYPE="$1"    # Expects "os" or "python"
SOURCE_PATH="$2"  # Expects the path to the file

handle_file() {
    local source_path="$1"
    local target_file="$2"

    if [ -z "$source_path" ]; then
        echo "❌ Error: No file path provided for this package type."
        exit 1
    fi

    # Expand tilde safely if the path starts with ~
    if [[ "$source_path" == "~"* ]]; then
        source_path="${source_path/#\~/$HOME}"
    fi

    if [ -f "$source_path" ]; then
        cp "$source_path" "$target_file"
        echo "✅ Successfully copied $(basename "$source_path") to $target_file"
    else
        echo "❌ Error: File not found at '$source_path'."
        exit 1
    fi
}

# Evaluate the package type provided in argument 1
case "$FILE_TYPE" in
    os)
        echo "📦 Processing OS packages..."
        handle_file "$SOURCE_PATH" "packages.txt"
        ;;
    python)
        echo "🐍 Processing Python dependencies..."
        handle_file "$SOURCE_PATH" "requirements.txt"
        ;;
    "")
        echo "⏭️  No package type provided. Skipping file configurations."
        ;;
    *)
        echo "❌ Error: Invalid type '$FILE_TYPE'. Use 'os' or 'python'."
        exit 1
        ;;
esac
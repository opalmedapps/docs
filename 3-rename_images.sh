#!/bin/bash
#  Script Name: rename_md_images.sh
#       Author: Gregor Mitchell - DevOps Admin - OHIG
#    Co-Author: Copilot
# Date Created: 2025-04-15
#      Version: 1.0.0 (2025-04-15)
#  Description: Processes markdown files with numbered images by:
#               - Renaming image files based on Figure descriptions
#               - Updating references in the markdown file
#               - Preserving all other content exactly
#               - Creating a backup of the original file

VERSION="1.0.0"
VERSION_DATE="2025-04-15"
DEBUG=false

# Error handling function
handle_error() {
    echo "Error at line ${BASH_LINENO[0]}. Restoring original file..." >&2
    if [ -f "${input_file}.ren" ]; then
        cp "${input_file}.ren" "$input_file"
    fi
    exit 1
}

# Debug output function
debug() {
    if $DEBUG; then
        echo "[DEBUG] $1" >&2
    fi
}

# Display version information
show_version() {
    cat <<EOF
rename_md_images.sh - Markdown Image Renamer
Version $VERSION ($VERSION_DATE)

Copyright (C) 2025 Opal Health Informatics Group
SPDX-License-Identifier: CC-BY-SA-4.0
EOF
    exit 0
}

# Display usage information
show_help() {
    cat <<EOF
rename_md_images.sh - Markdown Image Renamer (v$VERSION)

Usage: $0 [<input_file.md>] [options]

Options:
  -h, --help      Show this help message
  -v, --version   Show version information
  -d, --debug     Enable debug output

Processes a markdown file with numbered images by:
1. Renaming image files based on Figure descriptions
2. Updating references in the markdown file
3. Preserving all other content exactly
4. Creating a backup of the original file

If no file is specified, the script will:
- Look for .md files in current directory
- If one found, prompt to use it
- If multiple found, let you choose which to process
- If none found, display this help message

Example:
  $0 document.md
  - Will process document.md and create document.md.ren backup
  - Renames images from imageX.png to descriptive names
  - Updates all references in the markdown file
  - Original saved as document.md.ren

Requirements:
  - bash 4.0+
  - standard UNIX tools (sed, awk, grep)
EOF
    exit 0
}

# Function to select a markdown file from current directory
select_markdown_file() {
    local md_files=()
    local file_count=0
    local choice=0

    # Find all .md files in current directory
    debug "Searching for .md files in current directory"
    while IFS= read -r -d $'\0' file; do
        md_files+=("$file")
        ((file_count++))
    done < <(find . -maxdepth 1 -type f -name "*.md" -print0)

    debug "Found $file_count .md files"
    
    case $file_count in
        0)
            echo "No .md files found in current directory." >&2
            show_help
            ;;
        1)
            echo "Found markdown file: ${md_files[0]}"
            read -p "Press Enter to process this file or Ctrl-C to cancel..."
            input_file="${md_files[0]}"
            ;;
        *)
            echo "Multiple markdown files found:"
            for i in "${!md_files[@]}"; do
                printf "%2d) %s\n" "$((i+1))" "${md_files[$i]}"
            done
            while true; do
                read -p "Enter number of file to process (1-$file_count): " choice
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$file_count" ]; then
                    input_file="${md_files[$((choice-1))]}"
                    debug "User selected file: $input_file"
                    break
                else
                    echo "Invalid choice. Please enter a number between 1 and $file_count."
                fi
            done
            ;;
    esac
}

# Clean text by removing backslashes and extra spaces
clean_text() {
    local cleaned="${1//\\/}"
    cleaned=$(echo "$cleaned" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]\+/ /g')
    echo "$cleaned"
}

# Generate unique filename based on description
get_unique_filename() {
    local base=$(clean_text "$1")
    local ext="$2"
    local counter=2  # Start counting from 2 instead of 1
    local newfile="${base}.${ext}"
    
    # First try without number
    if [ ! -f "images/${newfile}" ]; then
        echo "$newfile"
        return
    fi
    
    # Then try with numbers starting from 2
    while [ -f "images/${base}${counter}.${ext}" ]; do
        ((counter++))
    done
    echo "${base}${counter}.${ext}"
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -d|--debug)
            DEBUG=true
            debug "Debug mode enabled"
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help
            ;;
        *)
            # First non-option argument is the input file
            if [[ -z "$input_file" ]]; then
                input_file="$1"
                debug "Input file specified: $input_file"
            else
                echo "Error: Multiple input files specified" >&2
                show_help
            fi
            shift
            ;;
    esac
done

# If no input file specified, search for .md files
if [[ -z "$input_file" ]]; then
    debug "No input file specified, searching for .md files"
    select_markdown_file
fi

# Validate input file
[ -f "$input_file" ] || { 
    echo "Error: Input file '$input_file' not found" >&2
    exit 1
}

debug "Processing file: $input_file"

# Create backup of original file
debug "Creating backup: ${input_file}.ren"
cp "$input_file" "${input_file}.ren" || handle_error

# Process the markdown file
temp_file=$(mktemp) || handle_error
trap 'rm -f "${temp_file}"' EXIT

echo -n "Processing images..."
image_count=0

while IFS= read -r line || [[ -n "$line" ]]; do
    line_trimmed=$(echo "$line" | sed 's/[[:space:]]*$//')
    
    if [[ "$line_trimmed" =~ ^\#?[[:space:]]*\!\[\]\((images/image[0-9]+\.png)\) ]]; then
        current_image="${BASH_REMATCH[1]#images/}"
        current_ext="${current_image##*.}"
        original_whitespace="${line%%[^[:space:]]*}"
        
        # Read next non-empty line for Figure
        while IFS= read -r figure_line; do
            figure_line_trimmed=$(echo "$figure_line" | sed 's/[[:space:]]*$//')
            [ -n "$figure_line_trimmed" ] && break
        done
        
        # Extract the original whitespace from the figure line
        figure_whitespace="${figure_line%%[^[:space:]]*}"
        
        # Clean the figure line content (without modifying whitespace)
        figure_content=$(echo "$figure_line_trimmed" | sed 's/^#[[:space:]]*//')
        
        if [[ "$figure_content" =~ ^[[:space:]]*Figure[[:space:]]*:[[:space:]]+([^:]+):([^:]+) ]]; then
            description=$(clean_text "${BASH_REMATCH[1]}")
            new_base=$(clean_text "${BASH_REMATCH[2]}")
            
            if [[ "$current_image" =~ image([0-9]+)\. ]]; then
                new_image=$(get_unique_filename "$new_base" "$current_ext")
                
                if [ -f "images/${current_image}" ]; then
                    debug "Renaming images/${current_image} to images/${new_image}"
                    mv -n "images/${current_image}" "images/${new_image}" || handle_error
                    # Preserve original whitespace for image line
                    echo -n "$original_whitespace" >> "$temp_file"
                    echo "![${description}](images/${new_image})" >> "$temp_file"
                    # Preserve original whitespace for figure line
                    echo -n "$figure_whitespace" >> "$temp_file"
                    echo "Figure: ${description}:${new_base}" >> "$temp_file"
                    ((image_count++))
                    echo -n "."
                    continue
                else
                    echo "ERROR: images/${current_image} not found" >&2
                fi
            fi
        else
            debug "No valid Figure line after image: '$figure_content'"
            echo "$line" >> "$temp_file"
            [ -n "$figure_line" ] && echo "$figure_line" >> "$temp_file"
            continue
        fi
    fi
    
    echo "$line" >> "$temp_file"
done < "$input_file"

# Replace original file with processed content
mv "$temp_file" "$input_file" || handle_error

# Completion message
cat <<EOF

Processing complete:
- Renamed $image_count images in ${input_file}
- Updated all references in the markdown file
- Backup saved as ${input_file}.ren

Version $VERSION completed successfully.
EOF

debug "Script completed successfully"
exit 0

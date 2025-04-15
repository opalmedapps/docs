#!/bin/bash
#  Script Name: process_md_file.sh
#       Author: Gregor Mitchell - DevOps Admin - OHIG
#    Co-Author: Copilot
# Date Created: 2025-04-09
#      Version: 2.0.4 (2025-04-12)
#  Description: Processes markdown files containing base64-encoded images by:
#               - Extracting all embedded images to an 'images' directory
#               - Converting all image references to inline format only (![](path))
#               - Removing all reference-style image definitions
#               - Adding standard SPDX header information
#               - Preserving all other content exactly
#               - Creating a backup of the original file
#               - Removing # from start of image reference lines

VERSION="2.0.4"
VERSION_DATE="2025-04-12"
DEBUG=false

# Error handling function
handle_error() {
    echo "Error at line ${BASH_LINENO[0]}. Restoring original file..." >&2
    if [ -f "${input_file}.bak" ]; then
        cp "${input_file}.bak" "$input_file"
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
process_md_file.sh - Markdown Image Processor
Version $VERSION ($VERSION_DATE)

Copyright (C) 2025 Opal Health Informatics Group
SPDX-License-Identifier: CC-BY-SA-4.0
EOF
    exit 0
}

# Display usage information
show_help() {
    cat <<EOF
process_md_file.sh - Markdown Image Processor (v$VERSION)

Usage: $0 [<input_file.md>] [options]

Options:
  -h, --help      Show this help message
  -v, --version   Show version information
  -d, --debug     Enable debug output

Processes a markdown file with embedded base64 images by:
1. Extracting all images to an 'images' subdirectory
2. Converting all image references to simple inline format
3. Removing reference-style image definitions
4. Adding standard SPDX header
5. Removing # from start of image reference lines
6. Preserving all other content

If no file is specified, the script will:
- Look for .md files in current directory
- If one found, prompt to use it
- If multiple found, let you choose which to process
- If none found, display this help message

Example:
  $0 document.md
  - Will process document.md and create document.md.bak backup
  - Images saved as images/image1.png, images/image2.jpg, etc.
  - All references converted to ![](images/imageX.ext) format
  - Original saved as document.md.bak

Requirements:
  - bash 4.0+
  - base64 utility
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

output_dir="images"

# Validate input file
[ -f "$input_file" ] || { 
    echo "Error: Input file '$input_file' not found" >&2
    exit 1
}

debug "Processing file: $input_file"
debug "Output directory: $output_dir"

# Initialize variables
declare -A image_map
temp_file=$(mktemp) || handle_error
processed_content=$(mktemp) || handle_error
trap 'rm -f "${temp_file}" "${processed_content}"' EXIT

# Create output directory for images
debug "Creating output directory: $output_dir"
mkdir -p "$output_dir" || handle_error

# Create backup of original file
debug "Creating backup: ${input_file}.bak"
cp "$input_file" "${input_file}.bak" || handle_error

# Extract and process images
echo -n "Extracting images..."
image_counter=1
while read -r base64_image; do
    image_format=$(echo "$base64_image" | sed -n 's/data:image\/\([a-zA-Z]*\);base64,.*/\1/p')
    base64_data=$(echo "$base64_image" | sed -n 's/data:image\/[a-zA-Z]*;base64,\(.*\)/\1/p')
    image_key="image${image_counter}"
    image_filename="${output_dir}/${image_key}.${image_format}"
    
    debug "Found image: format=$image_format, saving to $image_filename"
    
    if ! echo "$base64_data" | base64 --ignore-garbage -d > "$image_filename"; then
        echo "Failed to decode image ${image_counter}" >&2
        handle_error
    fi
    
    image_map["$image_key"]="$image_filename"
    printf "."
    ((image_counter++))
done < <(grep -o 'data:image/[a-zA-Z]*;base64,[^"]*' "$input_file")
image_count=$((image_counter-1))

debug "Extracted $image_count images"

# Generate image_map string for AWK
image_map_str=""
for key in "${!image_map[@]}"; do
    image_map_str+="${key}:${image_map[$key]} "
done

debug "Image map: $image_map_str"

# Process content with AWK
echo -e "\nProcessing markdown content..."
awk -v image_map_str="$image_map_str" '
BEGIN {
    split(image_map_str, pairs, " ")
    for (i in pairs) {
        if (pairs[i] != "") {
            split(pairs[i], kv, ":")
            image_map[kv[1]] = kv[2]
        }
    }
    skip_ref = 0
}
/^\[image[0-9]+]:/ {
    skip_ref = 1
    next
}
skip_ref && /^$/ {
    skip_ref = 0
    next
}
!skip_ref {
    # Remove # from start of image reference lines
    if ($0 ~ /^# ![[]/) {
        sub(/^# /, "", $0)
    }
    # Handle other image reference formats
    gsub("!\\[[^]]*\\]\\(#", "![](", $0)
    gsub("!\\[[^]]*\\]\\[#", "![](", $0)
    for (key in image_map) {
        gsub("!\\[[^]]*\\]\\[" key "\\]", "![](" image_map[key] ")", $0)
    }
    print
}' "$input_file" > "$processed_content" || handle_error

debug "Markdown content processed successfully"

# Add SPDX header to the final file
debug "Adding SPDX header"
(
    echo "<!--"
    echo "SPDX-FileCopyrightText: Copyright (C) 2025 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>"
    echo ""
    echo "SPDX-License-Identifier: CC-BY-SA-4.0"
    echo "-->"
    echo ""
    cat "$processed_content"
) > "$input_file" || handle_error

# Completion message
cat <<EOF

Processing complete:
- Extracted $image_count images to ${output_dir}/
- Converted all references to inline format: ![](images/imageX.ext)
- Removed all reference-style definitions
- Removed # from start of image reference lines
- Added SPDX header
- Backup saved as ${input_file}.bak

Version $VERSION completed successfully.
EOF

debug "Script completed successfully"
exit 0

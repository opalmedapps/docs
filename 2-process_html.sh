#!/bin/bash
# Script Name: reorder_images.sh
#      Author: Gregor Mitchell - DevOps Admin - OHIG
#   Co-Author: Deepseek Chat
# Date Created: 2025-04-14
#     Version: 3.8.0 (2025-04-15)
# Description: Reorders images in an .html document to be sequential

VERSION="3.8.0"
VERSION_DATE="2025-04-15"
DEBUG=false

# Display version information
show_version() {
    echo "$0 version $VERSION ($VERSION_DATE)"
    exit 0
}

# Display help
show_help() {
    echo "Usage: $0 [html_file]"
    echo "Reorders PNG images referenced in an HTML file to be sequential."
    echo "If no html_file is provided, will look for common HTML filenames."
    echo "If no HTML files found, will look for and extract a ZIP archive."
    echo "Options:"
    echo "  -v, --version  Show version information"
    echo "  -h, --help     Show this help message"
    exit 0
}

# Check for help or version flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)
            show_version
            ;;
        -h|--help)
            show_help
            ;;
        *)
            break
            ;;
    esac
done

# Function to find HTML file
find_html_file() {
    local common_names=("index.html" "document.html" "report.html" "file.html")
    
    for name in "${common_names[@]}"; do
        if [ -f "$name" ]; then
            echo "$name"
            return 0
        fi
    done
    
    # Check for any HTML file in current directory
    local found=$(find . -maxdepth 1 -name "*.html" -print -quit)
    if [ -n "$found" ]; then
        echo "$found"
        return 0
    fi
    
    return 1
}

# Function to find and extract ZIP file
find_and_extract_zip() {
    local zip_files=(*.zip)
    
    if [ ${#zip_files[@]} -eq 0 ]; then
        echo "Error: No HTML files found and no ZIP archive available" >&2
        return 1
    fi
    
    # Use the first ZIP file found
    local zip_file="${zip_files[0]}"
    
    read -p "No HTML files found. Extract from $zip_file? [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Extracting $zip_file..."
        if ! unzip -o "$zip_file"; then
            echo "Error: Failed to extract $zip_file" >&2
            return 1
        fi
        
        # Check if extraction produced any HTML files
        local extracted_html=$(find_html_file)
        if [ -n "$extracted_html" ]; then
            echo "Extracted HTML file: $extracted_html"
            html_file="$extracted_html"
            return 0
        else
            echo "Error: Extraction completed but no HTML files found" >&2
            return 1
        fi
    else
        echo "Aborting: No HTML files found and extraction declined." >&2
        return 1
    fi
}

# Determine HTML file
if [ "$#" -eq 0 ]; then
    echo "No HTML file specified. Searching for HTML files..."
    html_file=$(find_html_file)
    
    if [ -z "$html_file" ]; then
        echo "No HTML files found. Searching for ZIP archive..."
        if ! find_and_extract_zip; then
            exit 1
        fi
    else
        echo "Using found HTML file: $html_file"
    fi
else
    html_file=$1
fi

zip_file="${html_file%.*}.zip"

# Function to check for and extract zip if needed
check_and_extract() {
    if [ ! -f "$html_file" ] || [ ! -d "images" ]; then
        if [ -f "$zip_file" ]; then
            read -p "Required files not found. Extract from $zip_file? [y/N] " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                echo "Extracting $zip_file..."
                if ! unzip -o "$zip_file"; then
                    echo "Error: Failed to extract $zip_file" >&2
                    exit 1
                fi
                # Verify extraction was successful
                if [ ! -f "$html_file" ] || [ ! -d "images" ]; then
                    echo "Error: Extraction completed but $html_file or images directory still not found" >&2
                    exit 1
                fi
            else
                echo "Aborting: Required files not found and extraction declined." >&2
                exit 1
            fi
        else
            echo "Error: Neither $html_file nor $zip_file found, and images directory is missing" >&2
            exit 1
        fi
    fi
}

# Verify required files exist or try to extract them
check_and_extract

# Verify the HTML file is readable
if [ ! -r "$html_file" ]; then
    echo "Error: Cannot read HTML file '$html_file'" >&2
    exit 1
fi

# Define the patterns
pattern1='src="images/image[0-9]+\.png"'
pattern2='Figure:[^<]*'

# Temporary directory for safer file operations
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Process the HTML file
grep -o -E "$pattern1|$pattern2" "$html_file" | sed 's/<$//' | awk -v temp_dir="$temp_dir" '
BEGIN { 
    image = ""; 
    counter = 1;
    errors = 0;
}
{
    if ($0 ~ /src="images\/image[0-9]+\.png"/) {
        image = $0
    } else if ($0 ~ /^Figure:/) {
        if (image == "") {
            print "Warning: Figure caption without preceding image reference: " $0 > "/dev/stderr"
            errors++
            next
        }
        
        old_image = gensub(/src="([^"]*)"/, "\\1", "g", image)
        new_image = temp_dir "/image" counter ".png"
        
        if (system(sprintf("[ -f \"%s\" ]", old_image)) != 0) {
            print "Error: Source image not found: " old_image > "/dev/stderr"
            errors++
            counter++
            image = ""
            next
        }
        
        if (system(sprintf("mv -- \"%s\" \"%s\"", old_image, new_image)) != 0) {
            print "Error: Failed to move " old_image " to " new_image > "/dev/stderr"
            errors++
        }
        counter++
        image = ""
    }
}
END {
    if (errors > 0) {
        print "Processing completed with " errors " errors" > "/dev/stderr"
        exit 1
    }
}'

if [ $? -ne 0 ]; then
    echo "Error: Failed to process images" >&2
    exit 1
fi

# Move processed images back to images directory
if ! mv "$temp_dir"/*.png images/ 2>/dev/null; then
    echo "Error: Failed to move processed images" >&2
    exit 1
fi

echo "Successfully reordered images"
exit 0

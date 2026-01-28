#!/bin/bash

# Check if two prefixes are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <antigen_prefix> <nanobody_prefix>"
    exit 1
fi

# Assign the user-provided prefixes
antigen_prefix="$1"
nanobody_prefix="$2"
output_file="${nanobody_prefix}vs${antigen_prefix}.cfg"

# Use template file from current directory
template_file="./config_template.txt"

# Check if the template file exists
if [ ! -f "$template_file" ]; then
    echo "Error: Template file '$template_file' not found in current directory!"
    exit 1
fi

# Replace placeholders with user-provided prefixes and save as a new config file
sed -e "s/{antigen_prefix}/$antigen_prefix/g" -e "s/{nanobody_prefix}/$nanobody_prefix/g" "$template_file" > "$output_file"

if [ $? -eq 0 ]; then
    echo "Configuration file '$output_file' has been generated successfully."
else
    echo "Error: Failed to generate configuration file."
    exit 1
fi
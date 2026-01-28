#!/bin/bash

# Check if a prefix is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <antigen_prefix>"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Usage: $0 <nanobody_prefix>"
    exit 1
fi

# Set variables
#antigen_prefix=$1
#nanobody_prefix=$2
#filename="ambig${prefix}.tbl"
antigen_prefix=$(basename "$1") 
nanobody_prefix=$(basename "$2") 

# Removes directory components
#filename="ambig${nanobody_prefix}vs${antigen_prefix}.tbl"
# ...existing code...
filename="ambig${antigen_prefix}vs${nanobody_prefix}.tbl"
# ...existing code...
# Activate Conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate haddock3


# Run haddock3-restraints to generate the file
haddock3-restraints active_passive_to_ambig "${nanobody_prefix}_res.txt" "${antigen_prefix}_res.txt" > "$filename"

# Check if the file was created successfully
if [ ! -f "$filename" ]; then
    echo "Error: Failed to generate $filename"
    exit 1
fi

# Remove the first line and overwrite the file
tail -n +2 "$filename" > temp_file && mv temp_file "$filename"

echo "Successfully generated and cleaned $filename."

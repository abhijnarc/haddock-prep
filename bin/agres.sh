#!/usr/bin/env bash

# Activate Conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate haddock3

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <prefix>"
    exit 1
fi

antigen_prefix=$1
PDB_FILE="${antigen_prefix}_clean.pdb"
LOG_FILE="${antigen_prefix}_accessibility.log"
OUT_FILE="${antigen_prefix}_res.txt"

# Run haddock accessibility and save log
haddock3-restraints calc_accessibility --c 0.4 "$PDB_FILE" > "$LOG_FILE" 2>&1

# Extract 5th line, remove everything up to "Chain X - ", replace commas with spaces
{
  echo ""  # blank first line
  sed -n '5s/.*Chain [A-Z] - //p' "$LOG_FILE" \
    | tr ',' ' ' \
    | tr -s ' '
} > "$OUT_FILE"

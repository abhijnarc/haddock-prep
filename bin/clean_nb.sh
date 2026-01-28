#!/bin/bash
# Script for cleanup of all antibody PDB files in current directory

for input in *_igf.pdb; do
    pref="${input%.pdb}"
    output="${pref}_clean.pdb"
    hc="${pref}_H.pdb"

    echo "Processing $input..."

    # First the heavy chain
    cat "$input" | pdb_tidy -strict | pdb_selchain -H | pdb_delhetatm | \
             pdb_fixinsert | pdb_keepcoord | pdb_tidy -strict > "$hc"

    # Merge the chain and renumber
    pdb_merge "$hc" | pdb_chain -A | \
            pdb_chainxseg | pdb_reres | pdb_tidy -strict > "$output"
done

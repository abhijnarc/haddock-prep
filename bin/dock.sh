#!/bin/bash

# Check if a prefix is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <prefix>"
    exit 1
fi

# Set variables
antigen_prefix=$1
nanobody_prefix=$2

fasta_file="${nanobody_prefix}.fa"
igf_pdb="${nanobody_prefix}.pdb"
coord_file="${nanobody_prefix}_coord.csv"
nb_res_file="${nanobody_prefix}_res.txt"
ag_res_file="${antigen_prefix}_res.txt"
ambig_file="ambig${antigen_prefix}vs${nanobody_prefix}.tbl"

source "$(conda info --base)/etc/profile.d/conda.sh"

#Activate haddock envirnoment
conda activate haddock3

# Step 3: Parse the CDR regions from the FASTA file
echo "Running cdr_parse.py..."
python3 cdr_parse.py --fasta_file $fasta_file --prefix ${nanobody_prefix}

# ...existing code...
python3 abres.py $coord_file $nb_res_file
# ...existing code...

# Step 5: Generate the restraints file
echo "Running agres.sh..."
bash agres.sh $antigen_prefix

# Step 6: Generate the ambiguous restraints file
echo "Running ambig.sh..."
bash ambig.sh $antigen_prefix $nanobody_prefix

# Step 7: Generate the configuration file
echo "Running generate_config.sh..."
bash generate_config.sh $antigen_prefix $nanobody_prefix

echo "Pipeline completed successfully."

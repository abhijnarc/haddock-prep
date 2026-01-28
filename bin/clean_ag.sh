#/bin/bash
# script for cleanup of antigen pdb file
# we need to split the chain and shift residues since its a dimer
# get file prefix from command line
pref=$1
# set filenames
input=${pref}.pdb
output=${pref}_clean.pdb
ac=${pref}_A.pdb
# first the A chain
cat $input | pdb_tidy -strict | pdb_selchain -A | pdb_delhetatm | \
	 pdb_fixinsert | pdb_keepcoord | pdb_tidy -strict > $ac
# merge the two and renumber 
pdb_merge $ac | pdb_chain -B | \
	pdb_chainxseg | pdb_reres | pdb_tidy -strict > $output

# haddock-prep
This repository contains a modular Bash-based workflow for preparing
antibody–antigen docking inputs for HADDOCK. The workflow integrates
structure prediction, antibody/nanobody CDR extraction, residue definition,
and automated restraint and configuration generation.

## Workflow Components

| Step | Script | Input | Output | Purpose |
|-----:|--------|-------|--------|--------|
| 1 | igfold.py | FASTA | PDB | Predict antibody/nanobody structures |
| 2 | clean_ab.sh / clean_nb.sh | PDB | Cleaned PDB | Standardize structures for docking |
| 3 | ab_cdr.py / nb_cdr.py | FASTA | coord.csv | Identify CDR coordinates |
| 4 | abres.py / nbres.py | coord.csv | residue lists | Define paratope residues |
| 5 | agres.sh | HADDOCK cmd | residue list | Define antigen interface residues |
| 6 | ambig.sh | residue lists | ambig.tbl | Generate ambiguous restraints |
| 7 | unambig.sh | antibody PDB | unambig.tbl | Generate unambiguous restraints |
| 8 | generate_config.sh | templates | HADDOCK config | Produce final HADDOCK run config |

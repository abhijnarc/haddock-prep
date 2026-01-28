#!/usr/bin/env python3
import subprocess
import sys
import re

def run_accessibility(antigen_prefix):
    pdb_file = f"{antigen_prefix}_clean.pdb"
    log_file = f"{antigen_prefix}_accessibility.log"
    out_file = f"{antigen_prefix}_res.txt"

    # Run haddock3-restraints command and capture output
    with open(log_file, "w") as log:
        subprocess.run(
            ["haddock3-restraints", "calc_accessibility", "--c", "0.4", pdb_file],
            stdout=log,
            stderr=subprocess.STDOUT,
            check=True
        )

    residues = []
    with open(log_file) as f:
        for line in f:
            if "Chain" in line and re.search(r"\d", line):
                # Extract all numbers from residue list
                nums = re.findall(r"\d+", line)
                residues.extend(nums)

    # Remove commas, skip the first residue (start from index 2)
    residues = residues[1:]  

    # Write cleaned result file
    with open(out_file, "w") as f:
        f.write(" ".join(residues) + "\n")

    print(f"Residues written to {out_file}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python agres.py <prefix>")
        sys.exit(1)
    run_accessibility(sys.argv[1])

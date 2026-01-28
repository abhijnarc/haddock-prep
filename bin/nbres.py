import sys
import csv

def generate_restraints(input_csv, output_txt):
    try:
        with open(input_csv, 'r') as csvfile:
            reader = csv.DictReader(csvfile)
            with open(output_txt, 'w') as txtfile:
                for row in reader:
                    # Extract heavy CDR ranges (VH only)
                    heavy_cdr_ranges = [
                        range(int(row['hcdr1_start']), int(row['hcdr1_end']) + 1),
                        range(int(row['hcdr2_start']), int(row['hcdr2_end']) + 1),
                        range(int(row['hcdr3_start']), int(row['hcdr3_end']) + 1)
                    ]

                    # Combine, deduplicate, sort
                    all_cdr_residues = sorted(set(
                        num for cdr in heavy_cdr_ranges for num in cdr
                    ))

                    # Write to file
                    txtfile.write(' '.join(map(str, all_cdr_residues)) + '\n\n')

                    print(f"Processed {row['seq']} → VH residues written: {len(all_cdr_residues)}")

        print(f"\nVH restraint file generated: {output_txt}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python ab_res.py <input_csv> <output_txt>")
    else:
        generate_restraints(sys.argv[1], sys.argv[2])

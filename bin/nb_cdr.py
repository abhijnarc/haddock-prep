
import pandas as pd
from Bio import SeqIO
import argparse
import os

def parse_vh_fasta_and_process(fasta_file, prefix):
    heavy_sequence = None
    for record in SeqIO.parse(fasta_file, "fasta"):
        print(f"Processing record: {record.id}")  # Debugging
        if "VH" in record.id.upper():
            heavy_sequence = str(record.seq)

    if heavy_sequence:
        process_heavy_chain(heavy_sequence, prefix)
    else:
        print("No VH (heavy chain) sequence found in the FASTA file.")


def process_heavy_chain(heavy_sequence, prefix):
    print(f"Processing VH chain sequence: {heavy_sequence[:10]}...")  # Debugging
    url = f"http://www.abysis.org/abysis/sequence_input/key_annotation/key_annotation.cgi?aa_sequence={heavy_sequence}&nuc_sequence=&translation=sixft&humanorganism=on"
    try:
        tables = pd.read_html(url, match='Sequence Fragment', index_col=None)
        if not tables:
            print("No matching tables found.")
            return
        extracted_table = tables[5]
        cdr_table = extracted_table[extracted_table['Region'].isin(['CDR-H1', 'CDR-H2', 'CDR-H3'])]
        cdr_coords = {}
        for region in ['CDR-H1', 'CDR-H2', 'CDR-H3']:
            row = cdr_table[cdr_table['Region'] == region]
            if not row.empty:
                start, end = map(int, row['Residues'].iloc[0].split(' - '))
                cdr_coords[f'{region.lower()}_start'] = start
                cdr_coords[f'{region.lower()}_end'] = end
            else:
                cdr_coords[f'{region.lower()}_start'] = None
                cdr_coords[f'{region.lower()}_end'] = None

        hc_data = {
            'seq': [prefix],
            'hcdr1_start': [cdr_coords.get('cdr-h1_start')],
            'hcdr1_end': [cdr_coords.get('cdr-h1_end')],
            'hcdr2_start': [cdr_coords.get('cdr-h2_start')],
            'hcdr2_end': [cdr_coords.get('cdr-h2_end')],
            'hcdr3_start': [cdr_coords.get('cdr-h3_start')],
            'hcdr3_end': [cdr_coords.get('cdr-h3_end')]
        }
        hc_df = pd.DataFrame(hc_data)
        output_file = f'{prefix}_coord.csv'
        hc_df.to_csv(output_file, index=False)
        print("\nVH Chain CDR Data:")
        print(hc_df)
        print(f"\nData saved to {output_file}")
    except ValueError as ve:
        print(f"ValueError: {ve}")
    except Exception as e:
        print(f"An unexpected error occurred while processing VH chain: {e}")


## Light chain processing removed



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parse VH FASTA file and output CDR H1, H2, H3 coordinates.")
    parser.add_argument("--fasta_file", type=str, required=True, help="The path to the VH FASTA file containing sequences.")
    parser.add_argument("--prefix", type=str, required=True, help="The prefix for the output coord CSV file.")
    args = parser.parse_args()
    parse_vh_fasta_and_process(args.fasta_file, args.prefix)

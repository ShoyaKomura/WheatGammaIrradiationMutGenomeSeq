## Introduce deletions.
## <usage>
## python3 Make_deletion.py <input_fasta> <output_fasta>

from Bio import SeqIO
import random
import pandas as pd
import sys

args = sys.argv
input_file = args[1]
output_file = args[2]

chromosomes = ["chr3A", "chr3B", "chr3D"]
deletion_sizes = [1, 10, 100, 300, 500, 700, 1000, 5000, 10000]

def Remove_duplicate(df, dup_list):
    idx_num = len(df["chr"])
    for idx in range(0, idx_num-1):
        if df.iloc[idx, 0] != df.iloc[idx+1, 0]:
            pass
        else:
            if df.iloc[idx, 1] + df.iloc[idx, 2] >=  df.iloc[idx+1, 2]:
                df.iloc[idx+1, 1] = df.iloc[idx, 1] + df.iloc[idx+1, 1]
                df.iloc[idx+1, 2] = df.iloc[idx, 2]
                dup_list.append(idx)
    out_df = df.drop(index=dup_list)
    return out_df

def remove_str_start_end(seq, df):
    df_len = len(df["chr"])
    df["deletion_size(kb)"] = df["deletion_size(kb)"] * 1000
    if df_len == 0:
        out_seq = seq
    else:
        for idx in range(0, df_len):
            if idx == 0:
                out_seq = seq[:df.iloc[idx, 2]]
            else :
                out_seq += seq[df.iloc[idx-1, 1]+df.iloc[idx-1, 2]:df.iloc[idx, 2]]
        if df.iloc[df_len-1, 1]+df.iloc[df_len-1, 2] >= len(seq):
            pass
        else :
            out_seq += seq[df.iloc[df_len-1, 1]+df.iloc[df_len-1, 2]:]
    return out_seq

records = list(SeqIO.parse(input_file, "fasta"))

# determine the deletion region.
deletion_num = random.randrange(1, 10)
chromosome_length = [len(records[0].seq), len(records[1].seq), len(records[2].seq)]

deletion_chr = random.choices(chromosomes, k=deletion_num)
deletion_size = random.choices(deletion_sizes, k=deletion_num)

deletion_pd = pd.DataFrame({'chr':deletion_chr, 'deletion_size(kb)': deletion_size}).sort_values('chr')
chr3A_num = len(deletion_pd[deletion_pd["chr"]=="chr3A"])
chr3B_num = len(deletion_pd[deletion_pd["chr"]=="chr3B"])
chr3D_num = len(deletion_pd[deletion_pd["chr"]=="chr3D"])

chr3A_start_list = []
chr3B_start_list = []
chr3D_start_list = []

for i in range(0,chr3A_num):
    chr3A_start_pos = random.randrange(len(records[0].seq))
    chr3A_start_list.append(chr3A_start_pos)
    
for i in range(0,chr3B_num):
    chr3B_start_pos = random.randrange(len(records[0].seq))
    chr3B_start_list.append(chr3B_start_pos)
    
for i in range(0,chr3D_num):
    chr3D_start_pos = random.randrange(len(records[0].seq))
    chr3D_start_list.append(chr3D_start_pos)

start_list = chr3A_start_list + chr3B_start_list + chr3D_start_list
deletion_pd["position"] = start_list
deletion_pd = deletion_pd.sort_values(["chr", "position"])
deletion_pd.reset_index(inplace=True, drop=True)
dup_list=[]
out_df = Remove_duplicate(deletion_pd, dup_list)
out_df.reset_index(inplace=True, drop=True)
out_df.to_csv('deletion_position.tsv', sep="\t", index=False)

output_fasta = []

for idx in range(0, 3):
    output_chr = str(records[idx].id)
    input_seq = str(records[idx].seq)
    in_df = out_df[out_df["chr"]==chromosomes[idx]]
    del_seq = remove_str_start_end(input_seq, in_df)
    records_seq = [del_seq[i: i+60] + "\n" for i in range(0, len(del_seq), 60)]
    output_fasta += [">"+output_chr+"\n"] + records_seq

with open(output_file, "w") as output_handle:
    output_handle.writelines(output_fasta)   


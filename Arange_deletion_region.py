## Arrange deletion region detected with 99% or 95% confidence intervals.
## <usage>
## python3 Arrange_deletion_region.py <step size> <input_file> <output file name>

import pandas as pd
import sys

args = sys.argv

step_size= int(args[1])
input = args[2]
output = args[3]

in_df = pd.read_table(input, header= None, sep="\t", usecols=[0,1], names=["chr", "pos"])

start_list = []
end_list = []
chr_list=[]
chromosomes = ['chr1A', 'chr1B', 'chr1D', 'chr2A', 'chr2B', 'chr2D', 'chr3A', 'chr3B', 'chr3D', 'chr4A', 'chr4B', 'chr4D', 'chr5A', 'chr5B', 'chr5D', 'chr6A', 'chr6B', 'chr6D', 'chr7A', 'chr7B', 'chr7D']


for chromosome in chromosomes:
    df = in_df[in_df["chr"] == chromosome]
    len_df = len(df)
    pre_chr_num = len(chr_list)
    idx = 0
    while idx < len_df-1:
        start_idx = idx
        idx_pos = df.iloc[idx, 1]
        idx_next = df.iloc[idx+1, 1]
        if int(idx_next) - int(idx_pos) == step_size:
            while int(idx_next) - int(idx_pos) == step_size:
                idx += 1
                idx_pos = df.iloc[idx, 1]
                if idx == len_df-1 :
                    idx_next = df.iloc[idx, 1]
                else :
                    idx_next = df.iloc[idx+1, 1]
            start_list.append(df.iloc[start_idx, 1])
            end_list.append(df.iloc[idx, 1])
            idx +=1
        else :
            start_list.append(df.iloc[idx, 1])
            end_list.append(df.iloc[idx, 1])
            idx+=1
            if idx == len_df-1:
                start_list.append(df.iloc[idx, 1])
                end_list.append(df.iloc[idx, 1])
    
    for i in range(0, len(start_list)- pre_chr_num):
        chr_list.append(chromosome)

del_df = pd.DataFrame({"chr":chr_list, "start":start_list, "end":end_list})
del_df["size(kb)"] = (del_df["end"] - del_df["start"])/1000
del_df.to_csv(output, sep="\t", header = True, index = None)

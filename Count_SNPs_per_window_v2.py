## Calculate number of SNPs per window.
## <usage>
## python3 Count_SNPs_per_window.py <window_size> <Reference.fai> <input_file.vcf> <output_file>
## Load reference length from .fai (modified in v2)

import pandas as pd
import numpy as np
import re
import sys

args = sys.argv

bin_size = int(args[1])
Ref = args[2]
input_file = args[3]
output_file = args[4]

def cal_snp_num_per_bin(df, max_length):
    df_pos_series = df['pos']
    list_bin = np.arange(1, max_length, bin_size).tolist()
    number_of_SNPs_list = pd.value_counts(pd.cut(df_pos_series, list_bin)).sort_index().tolist()
    bin_start_list = list_bin[:-1]
    bin_end_list = list_bin[1:]
    return bin_start_list, bin_end_list, number_of_SNPs_list

def run_snp_per_bin(chr_name, chr_df):
    max_length = (chrsize_dic[chr_name]/bin_size + 1) * bin_size
    bin_start_list, bin_end_list, number_of_SNPs_list = cal_snp_num_per_bin(chr_df, max_length)
    for idx in range(0,len(number_of_SNPs_list)):
        start = int(bin_start_list[idx])
        end = int(bin_end_list[idx])
        N_SNPs = number_of_SNPs_list[idx]
        SNPs_per_window.write('{}\t{}\t{}\t{}\n'.format(chr_name,start, end, N_SNPs))
 
df_ref = pd.read_csv(Ref, delim_whitespace=True, usecols=[0,1], names=["chr", "len"])
chrsize_dic = dict(df_ref[["chr", "len"]].values)

vcf = open(input_file, "r")
count = 0
for line in vcf:
    if re.match(r'[^#]', line):
        value_head = count
    else :
        count += 1

df0 = pd.read_csv(input_file, delim_whitespace=True, skiprows=value_head, usecols=[0,1], names=["chr", "pos"])

grouped = df0.groupby('chr')

SNPs_per_window = open(output_file, 'w')

for chr_name, chr_df in grouped:
    run_snp_per_bin(chr_name, chr_df)


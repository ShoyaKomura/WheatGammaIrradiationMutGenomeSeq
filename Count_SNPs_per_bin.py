## Calculate number of SNPs per bin.
## <usage>
## python3 Count_SNPs_per_bin.py <bin_size> <input_file.vcf>

import pandas as pd
import numpy as np
import re
import sys

args = sys.argv

bin_size = int(args[1])
input_file = args[2]

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
        SNPs_per_bin.write('{}\t{}\t{}\t{}\n'.format(chr_name,start, end, N_SNPs))
        
chrsize_dic = {'chr1A' : 594102056,
'chr1B' : 689851870,
'chr1D' : 495453186,
'chr2A' : 780798557,
'chr2B' : 801256715,
'chr2D' : 651852609,
'chr3A' : 750843639,
'chr3B' : 830829764,
'chr3D' : 615552423,
'chr4A' : 744588157,
'chr4B' : 673617499,
'chr4D' : 509857067,
'chr5A' : 709773743,
'chr5B' : 713149757,
'chr5D' : 566080677,
'chr6A' : 618079260,
'chr6B' : 720988478,
'chr6D' : 473592718,
'chr7A' : 736706236,
'chr7B' : 750620385,
'chr7D' : 638686055}        


vcf = open(input_file, "r")
count = 0
for line in vcf:
    if re.match(r'[^#]', line):
        value_head = count
    else :
        count += 1

df0 = pd.read_csv(input_file, delim_whitespace=True, skiprows=value_head, usecols=[0,1], names=["chr", "pos"])

grouped = df0.groupby('chr')

SNPs_per_bin = open('Number_of_SNPs.tsv', 'w')

for chr_name, chr_df in grouped:
    run_snp_per_bin(chr_name, chr_df)


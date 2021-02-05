## Calculate number of SNPs per window.
## <usage>
## python3 Count_SNPs_per_window.py <window_size> <input_file.vcf> <output_name>

import pandas as pd
import re
import sys

args = sys.argv

input_file = args[1]
output_name = args[2]

vcf = open(input_file, "r")
count = 0
for line in vcf:
    if re.match(r'[^#]', line):
        value_head = count
    else :
        count += 1

df0 = pd.read_csv(input_file, delim_whitespace=True, skiprows=value_head, usecols=[0,1], names=["chr", "pos"])

df0.to_csv(output_name, sep='\t' , header=None, index=False)



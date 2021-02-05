## <Usage>
## pyton deletion_control.py <length of deletion(Mbp)> <Mut_depth_file.tsv.gz> <WT_depht_file.tsv.gz> <output_name.tsv.gz>


import numpy as np
import pandas as pd 
import sys

args = sys.argv

deletion_range = int(args[1])*1000000
Mut_depth_file = args[2]
WT_depth_file = args[3]
out_file_name = args[4]

recover_range = 741661832 - deletion_range
pre_deletion_idx = 673791504
recovered_range_idx = pre_deletion_idx + recover_range

deleterious_region_onWT = pd.read_csv(WT_depth_file, delim_whitespace=True, header=None, compression = 'gzip', usecols =[2], skipfooter = deletion_range, engine='python' ).values

deleterious_region_onMut = pd.read_csv(Mut_depth_file, delim_whitespace=True, header=None, compression = 'gzip')

deleterious_region_onMut.iloc[pre_deletion_idx:recover_range, 2] = deleterious_region_onWT

deleterious_region_onMut.to_csv(out_file_name, sep='\t' , header=None, index=False, compression='gzip')

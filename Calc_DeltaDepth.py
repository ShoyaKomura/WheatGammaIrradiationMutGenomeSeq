## <usage>
## python3 Calc_DepthGap.py <WT_moving_average.tsv> <Mut_moving_average.tsv> <output_name>

import numpy as np
import pandas as pd
import sys

args = sys.argv

in_WT_depth_all = args[1]
in_Mut_depth_all = args[2]
out_file = args[3]

def cal_random_gap(np_WT, np_Mut):
    WT_random = np.random.choice(np_WT)
    Mut_random = np.random.choice(np_Mut)
    random_gap = WT_random - Mut_random
    return random_gap

def cal_confidence(np_WT, np_Mut):
    random_gaps = []
    for i in range(0, 40000):
        random_gap = cal_random_gap(np_WT, np_Mut)
        random_gaps.append(random_gap)
    random_gaps.sort()
    return random_gaps[int(40000*0.95)], random_gaps[int(40000*0.99)]


WT_depth = pd.read_table(in_WT_depth_all, delimiter="\t",usecols=[0, 1, 3], names = ['chr', 'pos', 'mean'])
Mut_depth = pd.read_table(in_Mut_depth_all, delimiter="\t",usecols=[0, 1, 3], names = ['chr', 'pos', 'mean'])

WT_depth_mean = WT_depth["mean"].values
Mut_depth_mean = Mut_depth["mean"].values
Mut_depth['q95'] = 0
Mut_depth['q99'] = 0
WT_idx_limit = len(WT_depth.loc[:, 'mean'])
confidence_95, confidence_99 = cal_confidence(WT_depth_mean, Mut_depth_mean)
Mut_depth['q95'] = confidence_95
Mut_depth['q99'] = confidence_99
Mut_depth['WT'] = WT_depth['mean']

Mut_depth['mean_gap'] = Mut_depth['WT'] - Mut_depth['mean']
Mut_depth.to_csv(out_file, sep='\t' , header=1, index=False)

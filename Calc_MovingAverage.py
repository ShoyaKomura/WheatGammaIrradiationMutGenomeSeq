## <usage>
## python3 Calc_MovingAverage.py <window_size> <step_size> <input_file_name.tsv.gz> <output_file_name.tsv>

import pandas as pd

import numpy as np
import sys

args=sys.argv

window_size = int(args[1])
step_size = int(args[2])
input_file = args[3]
output_file = args[4]

df = pd.read_csv(input_file, delim_whitespace=True, header=None, compression='gzip')
df.columns = ['chr','pos','depth']
by = int(step_size)
df.loc[df.index[np.arange(len(df))%by==1],'Mean']=df.depth.rolling(window=int(window_size), center=True).mean()
df2 = df.dropna(axis = 0, how = 'any')
df2.to_csv(output_file, sep='\t' , header=None, index=False)

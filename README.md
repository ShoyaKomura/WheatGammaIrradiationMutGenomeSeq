# WheatGammaIrradiationMutGenomeSeq
Script that 
1. detects deletion or duplication induced by gamma-irradiation in bread wheat (*Triticum aestivum*) based on depth-of-coverage.
2. shows snp position or snp density over the chromosomes of wheat.

## 1. Detection of gamma-irradiation induced deletions
### Calculate moving average
```
python3 Calc_MovingAverage.py <Window_size> <Step_size> <Depth-of-coverage_at_each_position.tsv.gz> <Output_file_name.tsv>
```
- Depth-of-coverage_at_each_position.tsv.gz : Use `samtools depth` with -a option to compute the depth at each position from BAM.

When you calculated the moving average of all chromosomes, merge the results and sort by chrosome and the position.

Then, calculate delta-depth between two samples.
```
python3 Calc_DepthGap.py <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_file_name.tsv>
```
### 

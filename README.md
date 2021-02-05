# WheatGammaIrradiationMutGenomeSeq
Script that 
1. detects deletion or duplication induced by gamma-irradiation in bread wheat (*Triticum aestivum*) based on moving average of read depth.
2. shows snp position or snp density over the chromosomes of wheat.

## 1. Detection of gamma-irradiation induced deletions
### Calculate moving average
```
python3 Calc_MovingAverage.py <Window_size> <Step_size> <Depth-of-coverage_at_each_position.tsv.gz> <Output_file_name.tsv>
```
- `<Depth-of-coverage_at_each_position.tsv.gz>` : gzip compression file of read depth per chromosome.  
　　Use `samtools depth -a -r <chr1A>` to count read depth at all position of chr1A from BAM.

- `<Output_file_name.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - read depth at center position of each window
  - average depth of each window

When you calculated the moving average of all chromosomes, merge the results and sort by chrosome and the position.

If you calculate delta-depth between two samples, run `Calc_DeltaDepth.py`.
```
python3 Calc_DeltaDepth.py <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_file_name.tsv>
```
- `<Output_file_name.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - 95% confidence value 
  - 99% confidence value
  - differencee of read depth(delta-depth) between Sample1 and Sample2 at each window

### Visualization of moving average of read depth
Plot 

```
Rscript Plot_DeltaDepth.R <Calculated_delta-depth.tsv> <Output_prefix>
```
The output files named <output_prefix>\_chr<1A~7D>.png will be generated.


# WheatGammaIrradiationMutGenomeSeq
Script that 
1. Detects deletion or duplication induced by gamma-irradiation in wheat based on moving average of read depth.
 - [Plot the moving average for each of the two samples.](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-the-moving-average-for-each-of-the-two-samples)
 - [Plot delta-depth of two samples.](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-delta-depth-of-two-samples)
2. Shows snp position or snp density over the chromosomes of wheat.
 - [Plot SNP position](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-snp-position)
 - Plot SNP density

# 1. Detection of deletions incued by gamma-irradiation
## Plot the moving average for each of the two samples.
### Calculate moving average  
At first, count read dept hat all position from BAM.
```
samtools depth -a -r <chr1A-chr7D> <Input.bam> | gzip > <Depth-of-coverage_at_each_position_chrXX.tsv.gz> 
```
Then, calculate the moving average of read depth for each chromosome.
```
python3 Calc_MovingAverage.py <Window_size> <Step_size> <Depth-of-coverage_at_each_position_chrXX.tsv.gz> <Output_file.tsv>
```
- `<Depth-of-coverage_at_each_position.tsv.gz>` : gzip compression file of read depth per chromosome.  
- `<Output_file.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - read depth at center position of each window
  - average depth of each window

### Plot moving average
After the results have been **merged and sorted** by chromosome and position, run it.
```
Rscript Plot_MovingAverage.R  <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

## Plot delta-depth of two samples.
### Calculate delta-depth
At first, count read dept hat all position from BAM.
```
samtools depth -a -r <chr1A-chr7D> <Input.bam> | gzip > <Depth-of-coverage_at_each_position_chrXX.tsv.gz> 
```
Then, calculate the moving average of read depth for each chromosome.
```
python3 Calc_MovingAverage.py <Window_size> <Step_size> <Depth-of-coverage_at_each_position_chrXX.tsv.gz> <Output_file.tsv>
```
- `<Depth-of-coverage_at_each_position.tsv.gz>` : gzip compression file of read depth per chromosome.  
- `<Output_file.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - read depth at center position of each window
  - average depth of each window

After the results have been merged and sorted by chromosome and position, run it.
```
python3 Calc_DeltaDepth.py <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_file_name.tsv>
```
- `<Output_file_name.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - 95% confidence line
  - 99% confidence line
  - differencee of read depth(delta-depth) between Sample1 and Sample2 at each window
 
### Plot delta-depth
```
Rscript Plot_DeltaDepth.R <Calculated_delta-depth.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

# 2. Visualization of SNP position or SNP density
## Plot SNP position
At first, convert VCF file to input format.
```
python3 Vcf2SNP_position.py <Input_file.vcf> <Output_file.tsv>
```
- `<Output_file_name.tsv>` : columns in this order.
  - chromosome
  - SNP position 

Then, plot the position of SNPs:
```
Rscript Plot_SNP_position.R <Input_file.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

## Plot SNP density
Count the number of SNPs per each window
```
python3 Count_SNPs_per_window.py <Window_size> <Input.vcf>
```
- The output file `Number_of_SNPs.tsv` will be generated.
  - `Number_of_SNPs.tsv`: columns in this order.
  - chromosome
  - start position
  - end position
  - number of SNPs from start position to end position

Plot the SNP denstiy:
```
Rscript Plot_SNP_density.R <Input_file.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

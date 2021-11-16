# WheatGammaIrradiationMutGenomeSeq
Here is a source code repository for the following purpose, targeting wheat.  
 <br>
**1. Showing the moving average of depth-of-coverage.**
 - [The moving average for each of the two samples.](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-the-moving-average-for-each-of-the-two-samples)
 - [The difference of moving average(delta-depth) between two samples.](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-delta-depth-of-two-samples)

  **2. Showing snp position or snp density over the chromosomes of Chinese Spring(IWGSC v1.0).**
 - [SNP position](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-snp-position)
 - [SNP density](https://github.com/ShoyaKomura/WheatGammaIrradiationMutGenomeSeq/blob/main/README.md#plot-snp-density)

## 1. Showing the moving average of depth-of-coverage
### The moving average for each of the two samples. 
At first, count read depth at all position from BAM.
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

After the results have been **_merged and sorted_** by chromosome and position, run it.
```
Rscript Plot_MovingAverage.R  <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

### The difference of moving average(delta-depth) between two samples.
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

After the results have been **_merged and sorted_** by chromosome and position, run it.
```
python3 Calc_DeltaDepth.py <Sample1_MovingAverage_merged.tsv> <Sample2_MovingAverage_merged.tsv> <Output_file_name.tsv>
```
- `<Output_file_name.tsv>` : columns in this order.
  - chromosome
  - center position of each window
  - 95% confidence line
  - 99% confidence line
  - differencee of read depth(delta-depth) between Sample1 and Sample2 at each window

To estimate the deletion, use a program such as awk to extract regions that exceed the 95% or 99% confidence interval, and then run the following.
```
python Arange_deletion_region.py <Step_size> <Input_file_name.tsv> <Output_file_name.tsv>
```


### Plot delta-depth
```
Rscript Plot_DeltaDepth.R <Calculated_delta-depth.tsv> <Output_prefix>
```
- The output named <output_prefix>\_chr<1A~7D>.png will be generated.

## 2. Showing snp position or snp density over the chromosomes of Chinese Spring(IWGSC v1.0).
### SNP position
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

### SNP density
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

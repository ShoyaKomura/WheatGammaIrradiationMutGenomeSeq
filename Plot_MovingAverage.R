## Plot moving average of read depth
## <usage>
## Rscript Plot_MovingAverage.R <WT_input.tsv> <Mutant_input.tsv> <output_name_prefix>

list <- c("chr1A", "chr1B", "chr1D","chr2A", "chr2B", "chr2D","chr3A", "chr3B", "chr3D","chr4A", "chr4B", "chr4D","chr5A", "chr5B", "chr5D","chr6A", "chr6B", "chr6D","chr7A", "chr7B", "chr7D")

l <- list(chr1A=594102056,
chr1B=689851870,
chr1D=495453186,
chr2A=780798557,
chr2B=801256715,
chr2D=651852609,
chr3A=750843639,
chr3B=830829764,
chr3D=615552423,
chr4A=744588157,
chr4B=673617499,
chr4D=509857067,
chr5A=709773743,
chr5B=713149757,
chr5D=566080677,
chr6A=618079260,
chr6B=720988478,
chr6D=473592718,
chr7A=736706236,
chr7B=750620385,
chr7D=638686055)

input_file_WT <- commandArgs(trailingOnly=TRUE)[1]
input_file_Mut <- commandArgs(trailingOnly=TRUE)[2]
out_prefix <- commandArgs(trailingOnly=TRUE)[3]

df1 <- read.table(input_file_WT,header=0, sep="\t")
colnames(df1) <- c("chr","pos","depth","Mean")
df2 <- read.table(input_file_Mut,header=0, sep="\t")
colnames(df2) <- c("chr","pos","depth","Mean")

for (file_name in list){
library(ggplot2); theme_set(theme_bw())
df3 <- subset(df1, chr==file_name)
df4 <- subset(df2, chr==file_name)
save_figname <- paste(out_prefix, "_", file_name,".png", sep="")

p<-ggplot (NULL) +
geom_line(data= df3, aes(x=df3$pos/1000000, y=df3$Mean), colour="#FF5555")+
geom_line(data= df4, aes(x=df4$pos/1000000, y=df4$Mean), colour="#4B77BE")+
  labs (x=NULL, y=NULL)+
  scale_x_continuous(breaks = seq(0, l[[file_name]]/1000000, by=100), limits=c(0,l[[file_name]]/1000000), expand = c(0,0))+
  scale_y_continuous(breaks = seq(0, 1000, by=10),expand = c(0,0))+
  theme(plot.title = element_text(hjust=0.5))+
  theme(axis.text.x = element_text(size=16), axis.text.y = element_text(size=16))

print(p)
    ggsave(save_figname, p, width = 10, height = 2, dpi=300)}

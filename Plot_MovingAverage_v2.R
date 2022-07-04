## Plot moving average of read depth
## <usage>
## Rscript Plot_MovingAverage.R <WT_input.tsv> <Mutant_input.tsv> <output_name_prefix>

input_file_WT <- commandArgs(trailingOnly=TRUE)[1]
input_file_Mut <- commandArgs(trailingOnly=TRUE)[2]
out_prefix <- commandArgs(trailingOnly=TRUE)[3]

df1 <- read.table(input_file_WT,header=0, sep="\t")
colnames(df1) <- c("chr","pos","depth","Mean")
df2 <- read.table(input_file_Mut,header=0, sep="\t")
colnames(df2) <- c("chr","pos","depth","Mean")
chr_lists <- as.list(df1$chr)
list <- chr_lists[!duplicated(chr_lists)]

for (file_name in list){
library(ggplot2); theme_set(theme_bw())
df3 <- subset(df1, chr==file_name)
df4 <- subset(df2, chr==file_name)
save_figname <- paste(out_prefix, "_", file_name,".png", sep="")
chr_length <- tail(df3$pos, n=1)

p<-ggplot (NULL) +
geom_line(data= df3, aes(x=df3$pos/1000000, y=df3$Mean), colour="#FF5555")+
geom_line(data= df4, aes(x=df4$pos/1000000, y=df4$Mean), colour="#4B77BE")+
  labs (x=NULL, y=NULL)+
  scale_x_continuous(breaks = seq(0, chr_length/1000000, by=100), limits=c(0, chr_length/1000000), expand = c(0,0))+
  scale_y_continuous(breaks = seq(0, 1000, by=10),expand = c(0,0))+
  theme(plot.title = element_text(hjust=0.5))+
  theme(axis.text.x = element_text(size=16), axis.text.y = element_text(size=16))

print(p)
    ggsave(save_figname, p, width = 10, height = 2, dpi=300)}

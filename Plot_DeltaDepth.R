## Plot depth gap.
## <usage>
## Rscript Plot_MovingAverage.R <input_file.tsv> <output_name_prefix>

library(ggplot2)
library(dplyr)

input_file <- commandArgs(trailingOnly=TRUE)[1]
out_prefix <- commandArgs(trailingOnly=TRUE)[2]

df1 <- read.table(input_file,header=1, sep="\t")
chr_lists <- as.list(df1$chr)
list <- chr_lists[!duplicated(chr_lists)]

for (file_name in list){
    save_figname <- paste(out_prefix,"_",file_name,".png", sep="")
    df2 <- subset(df1, chr==file_name)
    library(ggplot2); theme_set(theme_bw())
    df4 <- mutate(df2, y_max = max(mean_gap)*1.05)
    df5 <- mutate(df4, y_min = min(mean_gap)*-1.05)
    chr_length <- tail(df5$pos, n=1)
    
    p<-ggplot (NULL) +
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$mean_gap), colour='black')+
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$q95), colour='orange')+
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$q99), colour='green4')+
      labs (x=NULL, y=NULL)+
      scale_x_continuous(breaks = seq(0, chr_length/1000000, by=100), limits=c(0, chr_length/1000000), expand = c(0,0))+
      theme(plot.title = element_text(hjust=0.5))+
      theme(axis.text.x = element_text(size=16), axis.text.y = element_text(size=16))+
      theme(plot.margin = margin(10, 1, 10, 10, "pt"))#URDL
    
    print(p)
    ggsave(save_figname, p, width = 10, height = 2, dpi=300)}

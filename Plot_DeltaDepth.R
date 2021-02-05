## Plot depth gap.
## <usage>
## Rscript Plot_MovingAverage.R <input_file.tsv> <output_name_prefix>

library(ggplot2)
library(dplyr)

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

input_file <- commandArgs(trailingOnly=TRUE)[1]
out_prefix <- commandArgs(trailingOnly=TRUE)[2]

df1 <- read.table(input_file,header=1, sep="\t")

for (file_name in list){
    save_figname <- paste(out_prefix,"_",file_name,".png", sep="")
    df2 <- subset(df1, chr==file_name)
    library(ggplot2); theme_set(theme_bw())
    df4 <- mutate(df2, y_max = max(mean_gap)*1.05)
    df5 <- mutate(df4, y_min = min(mean_gap)*-1.05)
    y_lim_u = c(max(df5$y_max))
    y_lim_d = c(min(df5$y_min))
    
    p<-ggplot (NULL) +
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$mean_gap), colour='black')+
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$q95), colour='orange')+
      geom_line(data= df5, aes(x=df5$pos/1000000, y=df5$q99), colour='green4')+
      labs (x=NULL, y=NULL)+
      scale_x_continuous(breaks = seq(0, l[[file_name]]/1000000, by=100), limits=c(0,l[[file_name]]/1000000), expand = c(0,0))+
      theme(plot.title = element_text(hjust=0.5))+
      theme(axis.text.x = element_blank(), axis.text.y = element_text(size=25))+
      theme(plot.margin = margin(10, 1, 10, 10, "pt"))#URDL
    
    print(p)
    ggsave(save_figname, p, width = 10, height = 2, dpi=300)}

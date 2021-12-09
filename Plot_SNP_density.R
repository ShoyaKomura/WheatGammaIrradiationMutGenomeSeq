## Plot SNP density.
## <usage>
## Rscript Plot_SNP_density.R <input.tsv> <output_prefix>

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

library (ggplot2)
library("scales")

infile = commandArgs(trailingOnly=TRUE)[1]
out_prefix = commandArgs(trailingOnly=TRUE)[2]

df0 <- read.table(infile, header=0, sep="\t")
density_limit <- max(df0$V4)

for (file_name in list){
save_figname <- paste(out_prefix,"_",file_name, ".png", sep="")

data <- subset(df0, df0$V1==file_name)
ghm <- ggplot (data, aes(x = 1 , y = V2/1000000 , fill = V4))+
        geom_tile()+
        theme_bw()+
        scale_y_continuous(breaks = seq(0, l[[file_name]]/1000000, by=100), limits=c(0,l[[file_name]]/1000000), expand = c(0,0))+
        scale_x_continuous(expand=c(0,0), breaks=NULL)+
        theme(panel.background = element_blank(),
                   panel.grid.minor = element_line(color = NA),
                   panel.grid.major = element_line(color = NA),
                   plot.background = element_blank())+
        theme(axis.text.x = element_text(size=15), axis.title.x = element_text(size=20), axis.title.y = element_blank())+
        scale_fill_gradientn(name="SNPs/bin", colours=c("white","black"), limits=c(0,density_limit), values=rescale(c(0,1,5)))+
        ylab('position(Mbp)') + coord_flip()+
        theme(plot.margin = margin(50, 5, 20, 5, "pt"))#URDL
ggsave(save_figname, ghm, width = 10, height = 2, dpi=300)}

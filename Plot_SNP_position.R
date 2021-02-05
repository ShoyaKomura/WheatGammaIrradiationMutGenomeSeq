## Plot SNP position.
## <usage>
## Rscript Plot_SNP_position.R <input_file> <output_prefix>

library(ggplot2)

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

input_file = commandArgs(trailingOnly=TRUE)[1]
out_preffix = commandArgs(trailingOnly=TRUE)[2]

df0 <- read.table(input_file, sep="\t")
colnames(df0) <- c("chr","pos")

for (file_name in list){
    save_figname <- paste(out_preffix, "_", file_name, ".png", sep="")
    df <- subset(df0, chr==file_name)
    
    g <- ggplot(df, aes(x=pos/1000000, y=1))+
    geom_bar(stat="identity", colour="black", width = 0.01)+
    labs(x="Position (Mb)", y="", title="")+
    scale_x_continuous(breaks = seq(0, l[[file_name]]/1000000, by=100), limits=c(0, l[[file_name]]/1000000), expand = c(0,0))+
    scale_y_continuous(expand=c(0,0), breaks=NULL, limits=c(0,1))+
    theme(panel.background = element_rect(fill = "transparent", color = "Black"),
    panel.grid.minor = element_line(color = NA),
    panel.grid.major = element_line(color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.key = element_rect(fill = "transparent", color = NA))
    g <- g+theme(axis.text.y = element_blank())
    
    plot(g)
    
    ggsave(save_figname, plot=g, width=10, height=1.0,dpi=300)}

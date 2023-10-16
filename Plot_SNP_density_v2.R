## Plot SNP density.
## <usage>
## Rscript Plot_SNP_density.R <input.tsv> <output_prefix>
library (ggplot2)
library("scales")

infile = commandArgs(trailingOnly=TRUE)[1]
out_prefix = commandArgs(trailingOnly=TRUE)[2]

df0 <- read.table(infile, header=0, sep="\t")
density_limit <- max(df0$V4)

chr_lists <- as.list(df0$V1)
list <- chr_lists[!duplicated(chr_lists)]

for (file_name in list){
save_figname <- paste(out_prefix,"_",file_name, ".png", sep="")

data <- subset(df0, df0$V1==file_name)
chr_length <- tail(data$V2, n=1)
ghm <- ggplot (data, aes(x = 1 , y = V2/1000000 , fill = V4))+
        geom_tile()+
        theme_bw()+
        scale_y_continuous(breaks = seq(0, chr_length/1000000, by=100), limits=c(0, chr_length/1000000), expand = c(0,0))+
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

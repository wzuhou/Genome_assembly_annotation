#Requirement
{suppressPackageStartupMessages(library(circlize))
suppressPackageStartupMessages(library(ComplexHeatmap))
library("wesanderson")
library(dplyr)
library(stringr)
library(tidyr)
library(plyr)
setwd("M:/circos_plot//")
}
#load chromosome coordinates
chrs = read.table("CHR_coords_1.bed", colClasses = c("character", "numeric", "numeric", "character"), sep = "\t")
names(chrs)<-c('scaffold','start','end','chr')
#Chr name manipulate
KeyMatch<-read.table('M:/circos_plot/Compare_chr_list.sort',header=F,col.names=c('chr','Chromosome'))
chrs<-chrs%>% filter(chr!='W') #Do not include W
{#Read-in
# GC
GC <- read.table("GC_CONTENT_200k_bedtools_nuc.bed")
colnames(GC) <- c("chr", "start", "end", "GC")
GC <- plyr::join(GC,KeyMatch,by="chr",type='left')
GC$chr=GC$Chromosome
# repeat
repeat_density_p <- read.table("REPEATS_200k.bed")#REPEATS_200k.bed
colnames(repeat_density_p) <- c("chr", "start", "end", "ovl")
repeat_density_p <- plyr::join(repeat_density_p,KeyMatch,by="chr",type='left')
repeat_density_p$chr=repeat_density_p$Chromosome
# Gaps and Ns
Ns <- read.table("Ns_200k.bed") #Ns_200k.bed
colnames(Ns) <- c("chr", "start", "end", "Ns")
Ns <- plyr::join(Ns,KeyMatch,by="chr",type='inner')
Ns$chr=Ns$Chromosome
}


{#color
col_text <- "grey8"
col_track1 <- "grey8"
col_track2 <- 'gray30' #"azure3" #Gaps and Ns
col_track3 <- '#CEAB07' # "#ff8400" #Repeat density
col_track4 <-   '#F3DF6C'#"#ffd000" #GC
}


#############
####PLOT#####
#############
{
#pdf("Chr_circos.pdf", width = 6, height = 6) 
circos.clear()
circos.par(points.overflow.warning=FALSE, "start.degree" = 90, canvas.ylim = c(-1,1), canvas.xlim = c(-1.1,1.1), "cell.padding" = c(0,0,0,0), "gap.degree" = c(2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,    2,2,2,2,2,2,2,2,2,2, 8))
circos.initialize(factors=chrs$chr, xlim=matrix(c(chrs$start,chrs$end),ncol=2))

#TRACK 1 - CHROMOSOMES
circos.track(ylim=c(0,1),panel.fun=function(x,y) {
  chr=CELL_META$sector.index
  xlim=CELL_META$xlim
  length= (max(xlim))
  length_label = paste((format(round(length/(10^6), 1), nsmall = 1)), "", sep="")
  ylim=CELL_META$ylim
  
  if(length > 63258489) {
    ticks = c(0, 50*10^6,  100*10^6,  200*10^6,  length)
    labels =  c("0", "50", "100",  "200",  length_label)
    circos.genomicAxis(h = "top", lwd = 0.2, major.at = ticks, labels = labels, 
                       labels.cex = 0.5, col=col_text, labels.col=col_text,
                       labels.facing="clockwise",
                       major.tick.length = convert_y(0.7, unit=c("mm")))
  } else if (length > 25880253){
    ticks = c(0, 50*10^6, 100*10^6, length)
    labels =  c("0", "50", "100", length_label)
    circos.genomicAxis(h = "top", lwd = 0.2, major.at = ticks, labels = labels, 
                       labels.cex = 0.5, col=col_text, labels.col=col_text,
                       labels.facing="clockwise",
                       major.tick.length = convert_y(0.7, unit=c("mm")))
  }else if (length > 16541138){
    ticks = c(0, length)
    labels = c("0", length_label)
    circos.genomicAxis(h = "top", lwd = 0.2, major.at = ticks, labels = labels, 
                       labels.cex = 0.5, col=col_text, labels.col=col_text,
                       labels.facing="clockwise",
                       major.tick.length = convert_y(0.7, unit=c("mm")))
  } else if (length > 2102120){
    ticks = c(0, length)
    labels = c("", length_label)
    circos.genomicAxis(h = "top", lwd = 0.2, major.at = ticks, labels = labels, 
                       labels.cex = 0.5, col=col_text, labels.col=col_text,
                       labels.facing="clockwise",
                       major.tick.length = convert_y(0.7, unit=c("mm")))
  } else {
    ticks = c(length)
    labels = c(length_label)
    circos.genomicAxis(h = "top", lwd = 0.2, major.at = ticks, labels = labels, 
                       labels.cex = 0.5, col=col_text,labels.col=col_text,
                       labels.facing="clockwise", minor.ticks=0, 
                       major.tick.length = convert_y(0.7, unit=c("mm")))}
  
  circos.text(mean(xlim), mean(ylim), chr, font = c(2), cex=0.48, col=col_track1, facing = "down")
  
},bg.col=wes_palette('Moonrise2', 35, type = "continuous") ,bg.border=NA,track.height=0.1)#"grey90"

#LEGEND
lgd = Legend(labels = c( "1.Chr","2.Ns and Gap","3.Repeats", "4.GC content"),
             labels_gp = gpar(fontsize=6), legend_gp = gpar(fill = c("#798E87",col_track2,col_track3,col_track4, lwd = 2)),
             grid_height = unit(3, "mm"), grid_width = unit(3, "mm"))#,col_track5,col_track6, col_track7, col_track8, col_track9, col_track10
draw(lgd, x = unit(2.5, "in"), y = unit(2, "in"), just = c("left"))



#TRACK2 -Gaps and Ns
colnames(Ns) <- c("chr", "start", "end", "Ns")
#add track
circos.genomicTrackPlotRegion(Ns, track.height = 0.06, panel.fun = function(region, value, ...) {
  circos.genomicLines(region, value, type = "h", lwd = 0.1, area=TRUE, border= col_track2, col = col_track2, ...)
}, ylim = range(Ns$Ns), bg.border = NA)
#add y axis
circos.yaxis(at=c(0, round(max(Ns$Ns)/2),(max(Ns$Ns))), labels = c(0,round((max(Ns$Ns)/2)),(max(Ns$Ns))), sector.index = "1", track.index = get.current.track.index(),
             labels.cex=0.31, lwd=0, labels.col=col_text, col=col_text, tick = TRUE,
             tick.length = convert_x(0.4, "mm", sector.index = get.current.sector.index(), track.index=get.current.track.index()))

#TRACK 3 - REPEATS DENSITY
#load file with intersection between repeats bases and 200 kbp windows (bedtools intersect)
colnames(repeat_density_p) <- c("chr", "start", "end", "ovl")
#aggregate windows when chr, start, ends coincide
repeat_desity_p_agg <- aggregate(.~chr+start+end, repeat_density_p, sum)
#calculate fraction of the windows covered by repeats
repeat_desity_p_agg_percent <- data.frame(repeat_desity_p_agg$chr, repeat_desity_p_agg$start, repeat_desity_p_agg$end, (repeat_desity_p_agg$ovl/(repeat_desity_p_agg$end-repeat_desity_p_agg$start))*100)
colnames(repeat_desity_p_agg_percent) <- c("chr", "start", "end", "repeats")
#add track
circos.genomicTrackPlotRegion(repeat_desity_p_agg_percent, track.height = 0.06, panel.fun = function(region, value, ...) {
  circos.genomicLines(region, value, type = "l", lwd = 0.1, area=TRUE, border= col_track3, col = col_track3,  ...)
}, ylim = range(repeat_desity_p_agg_percent$repeats), bg.border = NA)
#add y axis
circos.yaxis(at=c(0, (max(repeat_desity_p_agg_percent$repeats)/2), max(repeat_desity_p_agg_percent$repeats)), labels = c(0,"50","100"), sector.index = "1", track.index = get.current.track.index(),
             labels.cex=0.31, lwd=0, labels.col=col_text, col=col_text, tick = TRUE,
             tick.length = convert_x(0.4, "mm", sector.index = get.current.sector.index(), track.index=get.current.track.index()))

#TRACK 4 - GC CONTENT
#load GC content calculated with bedtools nuc on 200 kbp windows
colnames(GC) <- c("chr", "start", "end", "GC") 
#add track
circos.genomicTrackPlotRegion(GC, track.height = 0.06, panel.fun = function(region, value, ...) {
  circos.genomicLines(region, value, type = "l", lwd = 0.1, area=TRUE, border= col_track4, col = col_track4, ...)
}, ylim = c(0,1), bg.border = NA)# ylim = range(GC$GC)
#quantile(GC$GC)
#add y axis #at=c(45, (max(GC$GC)))
circos.yaxis(at=c(0.5, 1), labels = c('50',"100"), sector.index = "1", track.index = get.current.track.index(), 
             labels.cex=0.30, lwd=0, labels.col=col_text, col=col_text, tick = TRUE, 
             tick.length = convert_x(0.4, "mm", sector.index = get.current.sector.index(), track.index=get.current.track.index())) 

dev.off()
}

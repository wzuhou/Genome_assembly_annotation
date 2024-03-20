setwd('./WCS/Annotation/')
{library(tidyverse)
library(ggrepel)
library(ggplot2)
library(wesanderson)
library(gridExtra)
#library(plyr)
library(dplyr)
library(stringr)
}
#####################################
# p1 and p2
#####################################

## files required for matching
KeyMatch<-read.table('./WCS/WCS_Genome/circos_plot/Compare_chr_list.sort',header=F,col.names=c('chr','Chromosome'))
chrs = read.table("./WCS/WCS_Genome/circos_plot/CHR_coords_1.bed", colClasses = c("character", "numeric", "numeric", "character"), sep = "\t")
names(chrs)<-c('scaffold','start','end','chr')
chrs<-chrs%>%
  filter(chr!='W')
KeyMatch<-KeyMatch%>%
  filter(Chromosome!='W')
# Read in GC file
#setwd("./WCS/WCS_Genome/circos_plot//")
GC <- read_tsv("./WCS/WCS_Genome/circos_plot/GWCS.softmasked.fasta.fsa.seqkittab",col_names = c('chr','GC'),col_types = cols(
 chr = "f",GC='n'))
GC$start= 0
GC$end<- str_split(GC$chr,'_',simplify = T)[,3]
GC<-GC[,c("chr", "start", "end", "GC")]
#colnames(GC) <- c("chr", "start", "end", "GC")
GC <- plyr::join(GC,KeyMatch,by="chr",type='left')
head(GC)
GC$chr<-GC$Chromosome
GC <- GC[,1:4]

GC<-GC%>%
  drop_na()

detach(package:plyr)
#not using the windowed GC, thus
GC_sum=GC
GC_sum$end<-as.numeric(as.character(GC_sum$end))
GC_sum$chr<-as.factor(as.character(GC_sum$chr))

#GC contents By size
sizeorder=chrs[order(chrs$end,decreasing = T),]
#Test correlation P vsl
cor(GC_sum$end, GC_sum$GC, method =  "spearman")#spearman rank
cor.test(GC_sum$end, GC_sum$GC, method =  "spearman")

p1<-ggplot(GC_sum,aes(x=log(end), y= GC,color = factor(chr),label = factor(chr)))+
  xlab('Chr length (log)')+
  ylab('GC content %')+
  scale_color_manual(values=wes_palette('Moonrise2', 35, type = "continuous"))+
  #labs(title = "Chr GC content",)+
  annotate("text", x = 15.5, y = 40, label = "P< 2.2e-16\nrho=-0.99",color='gray30')+
  #geom_smooth(method = lm, se = FALSE)+
  geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p1

####################Read in reapeat file

# repeat
repeat_density_p <- read.table("./WCS/WCS_Genome/circos_plot/REPEATS_200k.bed",sep=" ",col.names = c("chr", "start", "end", "ovl"))#REPEATS_200k.bed

head(repeat_density_p)

repeat_sum<-
  repeat_density_p%>%
  group_by(chr)%>%
  summarise(Repeats=sum(ovl)) %>%
  mutate(start=0,
         end=as.numeric(str_split(chr,'_',simplify = T)[,3]),
         Rep= (100*Repeats/end),
  ) %>%
  select(chr,start,end,Rep)%>%
  left_join(KeyMatch,by="chr")%>%
  drop_na()%>%
  select(Chromosome,start,end,Rep) 

  colnames(repeat_sum)=c("chr", "start", "end", "Rep")

#GC contents By size
sizeorder=chrs[order(chrs$end,decreasing = T),]

#Or x axis use length  
#Test correlation P vsl
cor(repeat_sum$end, repeat_sum$Rep, method =  "spearman")#spearman rank
cor.test(repeat_sum$end, repeat_sum$Rep, method =  "spearman")
library(ggrepel)

p2<-ggplot(repeat_sum,aes(x=log(end), y=Rep,color = factor(chr),label = chr))+
  xlab('Chr length (log)')+
  ylab('Repeat content %')+
  scale_color_manual(values=wes_palette('Moonrise2', 35, type = "continuous"))+
  #labs(title = "Chr GC content",)+
  annotate("text", x = 15.5, y = 6, label = "P=6.103e-05\nrho=-0.67",color='gray30')+
  #geom_smooth(method = lm, se = FALSE)+
  geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p2

#####################################
# p3 and p4
#####################################
df1<-read_tsv(
  'evm_GWCS_13.EVM.gff3',
  col_names = c(
    "chrom" ,
    "source" ,
    "type" ,
    "start",
    "end",
    "score",
    "strand",
    "phase",
    "attributes"),
  col_types = cols(
    chrom = "c",
    source="c",
    type="c",
    start = "i",
    end = "i",
    score = 'c',
    strand = 'c',
    phase='c',
    attributes = 'c'))
head(df1)

unique(df1$type)

print((table(df1$type)))
stat1<- df1%>%
  filter(type=='gene') %>%
  group_by(chrom) %>%
  summarize( N_gene = n()) %>%
  arrange(desc(N_gene))
tail(stat1)

stat1$chr_num<-str_split(stat1$chrom,'_',simplify = T)[,2]
stat1$chr_size<-str_split(stat1$chrom,'_',simplify = T)[,3]
stat1$chr_size<-as.integer(stat1$chr_size)
#gene contents By size
sizeorder=stat1[order(stat1$chr_size,decreasing = T),]

# Key1<-read.table('./WCS/WCS_Genome/circos_plot/Compare_chr_list',header=F,col.names=c('chr','Chromosome'))
# Key2<-read.table('./WCS/WCS_Genome/Comparative/Gambels_rm200_mk_adaptor_art.fa.POL3_Pi2.fa.fasta.fai.scaffold_nm',header=F,col.names=c('chr_ori','scaffold'))
# Key2$chr<-str_split(Key2$chr_ori,'_p',simplify = T)[,1]
# Keys<-plyr::join(Key2,Key1,by="chr",type='right')
# #write.table(Keys,'./WCS/WCS_Genome/Comparative/Gambels_matching_scaffold_nm.txt',row.names = F,col.names = F,quote = F)
# #KeyMatch<-Keys[c('scaffold','Chromosome')];

KeyMatch<-read.table('./WCS/WCS_Genome/circos_plot/Compare_chr_list.sort',header=F,col.names=c('chr','Chromosome'))
names(KeyMatch)<-c('chrom','Chromosome')
KeyMatch<-KeyMatch%>%
  filter(Chromosome!='W')
stat0<-stat1
stat1<-plyr::join(stat1,KeyMatch,by="chrom",type='right')
#Plot and  p val
#Test correlation P vsl
cor(stat0$chr_size, stat0$N_gene, method =  "spearman")#spearman rank
cor.test(stat0$chr_size, stat0$N_gene, method =  "spearman", exact = FALSE)
# library(ggrepel)
# library(ggplot2)

stat1$Chromosome<-as.factor(as.character(stat1$Chromosome))
stat1$chrom<-as.factor(as.character(stat1$chrom))
stat1$N_gene<-as.numeric(stat1$N_gene)

p3<-ggplot(stat1,aes(x=log(chr_size), y=N_gene,color = factor(chrom),label = Chromosome ))+ #,label = chrom
  xlab('Chr length (log)')+
  ylab('Gene number')+
  scale_color_manual(values=wes_palette('Moonrise2', 35, type = "continuous"))+
  #labs(title = "Chr gene number",)+
  annotate("text", x = 18, y = 6, label = "P< 2.2e-16\nrho=0.75",color='gray30')+
  #geom_smooth(method = lm, se = FALSE)+
  geom_smooth(color = alpha('gray30',0.3), size=0.8, method = lm, se = FALSE, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p3

##########Gene density
library(RIdeogram)
test_karyotype<-read.table("test_karyotype_major.txt", sep = "\t", header = T, stringsAsFactors = F)
gene_density <- GFFex(input = "evm_GWCS_13.EVM.gff3.major_rnm.gff3", karyotype = 'test_karyotype_major.txt', feature = "gene", window = 100000)
ideogram(karyotype = test_karyotype,overlaid = gene_density) #,colorset1 = c("#f7f7f7", "#e34a33")
#convertSVG("chromosome.svg", device = "png")

#detach(package:plyr)
tail(gene_density)
gene_density<-tibble(gene_density)

GD<- gene_density %>%
  #mutate(Dense= Value/100000) %>%
  group_by(Chr) %>%
  summarize(Gene_total= sum(Value),
            Gene_dens=mean(Value),
            size=max(End))%>%
  arrange(as.factor(as.character(Chr)))%>%
  write_tsv("Gene_density_by_chr.txt")

#Plot and  p val
#Test correlation P vsl
names(GD)<-c('Chromosome', "Gene_total", "Gene_dens" , "Size" )
GD1<-plyr::join(GD,stat1,by="Chromosome",type='left')
GD1<-as.data.frame(GD1)
cor(GD1$Size, GD1$Gene_dens, method =  "spearman")#spearman rank
cor.test(GD1$Size, GD1$Gene_dens, method =  "spearman", exact = FALSE)

p4<-ggplot(GD1,aes(x=log(Size), y=Gene_dens,color = factor(Chromosome),label = Chromosome ))+ #,label = chrom
  xlab('Chr length (log)')+
  ylab('Gene density (100Kb window)')+
  scale_color_manual(values=wes_palette('Moonrise2', 35, type = "continuous"))+
  #labs(title = "Chr gene number",)+
  annotate("text", x = 15.5, y = 1, label = "P< 2.2e-16\nrho=-0.98",color='gray30')+
  #geom_smooth(method = lm, se = FALSE)+
  geom_smooth(color = alpha('gray10',0.3), size=0.8, method = lm, se = F, fullrange = TRUE,linetype ='dashed') + 
  geom_point()+
  geom_text_repel(nudge_y = -0.08, max.overlaps = Inf) + #this is to label the point
  theme_classic()+
  theme(legend.position = "none",axis.text.x =element_text(size=8))

p4

p_c<-gridExtra::grid.arrange(p1,p2,p3,p4, ncol=2)
ggsave('Chr_GC_repeat_gene_density_bysize.pdf',p_c,width = 10,height = 8,unit='in',dpi = 300)
ggsave('Chr_GC_repeat_gene_density_bysize.png',p_c,width = 10,height = 8,unit='in',dpi = 600)

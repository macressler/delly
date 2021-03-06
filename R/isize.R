library(ggplot2)
library(grid)
library(diptest)

args=commandArgs(trailingOnly=TRUE)
orient=c("F+", "F-", "R+", "R-")
ins=read.table(args[1], header=T)
count=c()
titleVal="Insert Size ("
for (o in orient) {
    s=sum(ins[ins$Orient==o,]$Count)
    count=c(count, s)
    lab=paste("#", o, ":", s, sep="")
    titleVal=paste(titleVal, lab, sep="  ")
}
countTotal=sum(count)

dpS = sample(rep(ins$Size, ins$Count), 10000)
dipTest = (d.t <- dip.test(dpS))
dipStat = round(dipTest$statistic,3)
dipPval = round(dipTest$p.value,3)
titleVal=paste(titleVal, " - Dn:", dipStat, " pval:", dipPval, " )", sep="")

# Theme
txtFontSize=10; axisFontSize=16; axisTtlFontSize=18; lgdTtlFontSize=18; lgdFontSize=16;
sth=theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank(), legend.key=element_blank(), legend.background=element_blank(), panel.background = element_blank(), panel.border=element_blank(), strip.background = element_blank(), axis.line=element_line(size=0.7, color="black"), axis.text.x=element_text(size=axisFontSize), axis.text.y=element_text(size=axisFontSize), axis.title.x=element_text(size=axisTtlFontSize), axis.title.y=element_text(size=axisTtlFontSize), legend.title=element_text(size=lgdTtlFontSize, face="bold"), legend.text=element_text(size=lgdFontSize), text=element_text(size=txtFontSize), plot.title=element_text(size=axisTtlFontSize), strip.text.x=element_text(size=axisTtlFontSize))

png(paste(args[1], "png", sep="."), height=800, width=800)
grid.newpage()
pushViewport(viewport(layout=grid.layout(4,2)))
p1=ggplot(data=ins) + geom_histogram(aes(x=Size, y=Count, colour=Orientation, fill=Orientation), stat="identity") + ggtitle(titleVal) + sth
p2=ggplot(data=ins) + geom_histogram(aes(x=Size, y=Count, colour=Orientation, fill=Orientation), stat="identity") + facet_wrap(~ Orientation, nrow=2, ncol=2) + sth
print(p1, vp = viewport(layout.pos.row=1:2, layout.pos.col=1:2))
print(p2, vp = viewport(layout.pos.row=3:4, layout.pos.col=1:2))
z=dev.off()


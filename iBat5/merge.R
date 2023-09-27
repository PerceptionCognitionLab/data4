# tool for merging csv's for this experiment
# to use: Rscript --vanilla merge.R outputFileName


args = commandArgs(trailingOnly=TRUE)
filenames=list.files(pattern="csv")

out=list()
for (i in 1:length(filenames)){
  dat=read.csv(filenames[i])
  rowSelect <- dat$task %in% c("br","eb","pog","pz","zol")
  colSelect <- c("pid","sid","task","resp","start","version","parA","rt","time_elapsed","block")
  out1=dat[rowSelect,colSelect]
  out[[i]] = out1
}

allDat=do.call(rbind,out)
rownames(allDat)=NULL
write.table(allDat,file=args[1],quote=F,row.names = F)

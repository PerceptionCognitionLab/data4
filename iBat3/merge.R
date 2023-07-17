# tool for merging csv's for this experiment
# to use: Rscript --vanilla merge.R outputFileName


args = commandArgs(trailingOnly=TRUE)
library(tidyverse)
filenames=list.files(pattern="csv")

out=NULL
for (i in 1:length(filenames)){
  dat=read.csv(filenames[i])
  rowSelect <- dat$task %in% c("br","eb","pog","pz","zol")
  out1=select(dat[rowSelect,],pid,task,resp,start,version,parA,rt,time_elapsed)
  out=rbind(out,out1)
}

rownames(out)=NULL
write.table(out,file=args[1],quote=F,row.names = F)

makeDat = function(){
  directoryPath = "."
  filenames = list.files(path=directoryPath, pattern="*.csv")
  out_list = list()
  
  for (i in 1:length(filenames)){
    dat = read.csv(paste0(directoryPath, "/", filenames[i]))
    
    rowSelect = dat$task %in% c("br","eb","pog","pz","zol")
    out1 = dat[rowSelect, c("pid", 
                            "task", 
                            "resp", 
                            "start", 
                            "version", 
                            "parA", 
                            "rt", 
                            "time_elapsed", 
                            "sid", 
                            "block",
                            "jitterX",
                            "jitterY")]
    
    out_list[[i]] = out1
  }
  
  all_data = do.call(rbind, out_list)
  all_data$sub = as.numeric(factor(all_data$pid))
  
  repeat_pid = names(which(table(all_data$pid)>150))
  
  tdat = all_data[all_data$pid == repeat_pid,]
  sid_rep = unique(tdat$sid)
  bad_sid = sid_rep[2]
  all_data = all_data[!all_data$sid==bad_sid,]
  
  all_data$y = NA
  
  ind = which(all_data$task=="br")
  all_data[ind,]$y = all_data[ind,]$resp/all_data[ind,]$parA
  ind = which(all_data$task=="br" & all_data$version == 1)
  all_data[ind,]$y = -all_data[ind,]$y
  
  ind = which(all_data$task=="eb" & all_data$version == 2)
  all_data[ind,]$y = (all_data[ind,]$resp-all_data[ind,]$parA)/all_data[ind,]$parA
  ind = which(all_data$task=="eb" & all_data$version == 1)
  all_data[ind,]$y = (all_data[ind,]$parA-all_data[ind,]$resp)/all_data[ind,]$parA
  
  ind = which(all_data$task=="pog")
  all_data[ind,]$y = all_data[ind,]$resp-all_data[ind,]$parA
  ind = which(all_data$task=="pog" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  
  
  ind = which(all_data$task=="pz")
  all_data[ind,]$y = (all_data[ind,]$resp-all_data[ind,]$parA)/all_data[ind,]$parA
  ind = which(all_data$task=="pz" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  
  
  ind = which(all_data$task=="zol")
  all_data[ind,]$y = all_data[ind,]$resp
  ind = which(all_data$task=="zol" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  all_data$y = all_data$y
  
  
  ind = which(all_data$rt == "null")
  all_data[ind,]$rt = 8000
  all_data$rt = as.numeric(all_data$rt)
  
  all_data$block = rep(rep(c(1,2),each = 75), max(all_data$sub))
  
  write.csv(all_dat, "raw_merged_data.csv")
}
makeDat()

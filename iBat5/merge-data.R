
# Initialize Function
makeDat = function(){
  
  # Processing Each CSV File:
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
  
  # Combining Data
  all_data = do.call(rbind, out_list)
  all_data$sub = as.numeric(factor(all_data$pid))
  
  # Getting rid of repeat participants
  repeat_pid = names(which(table(all_data$pid)>150))
  
  tdat = all_data[all_data$pid == repeat_pid,]
  sid_rep = unique(tdat$sid)
  bad_sid = sid_rep[2]
  all_data = all_data[!all_data$sid==bad_sid,]
  
  
  # Creating Scores for each task
  all_data$y = NA
  
  # Brentano
  ind = which(all_data$task=="br")
  all_data[ind,]$y = all_data[ind,]$resp/all_data[ind,]$parA
  ind = which(all_data$task=="br" & all_data$version == 1)
  all_data[ind,]$y = -all_data[ind,]$y
  
  # Ebbinghaus
  ind = which(all_data$task=="eb" & all_data$version == 2)
  all_data[ind,]$y = (all_data[ind,]$resp-all_data[ind,]$parA)/all_data[ind,]$parA
  ind = which(all_data$task=="eb" & all_data$version == 1)
  all_data[ind,]$y = (all_data[ind,]$parA-all_data[ind,]$resp)/all_data[ind,]$parA
  
  # Poggendorf
  ind = which(all_data$task=="pog")
  all_data[ind,]$y = all_data[ind,]$resp-all_data[ind,]$parA
  ind = which(all_data$task=="pog" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  
  # Panzo
  ind = which(all_data$task=="pz")
  all_data[ind,]$y = (all_data[ind,]$resp-all_data[ind,]$parA)/all_data[ind,]$parA
  ind = which(all_data$task=="pz" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  
  # Zoellner
  ind = which(all_data$task=="zol")
  all_data[ind,]$y = all_data[ind,]$resp
  ind = which(all_data$task=="zol" & all_data$version == 2)
  all_data[ind,]$y = -all_data[ind,]$y
  all_data$y = all_data$y
  
  # Fixing RTs
  ind = which(all_data$rt == "null")
  all_data[ind,]$rt = 8000
  all_data$rt = as.numeric(all_data$rt)
  
  # Fixing Blocks
  all_data$block = rep(rep(c(1,2),each = 75), max(all_data$sub))
  
  # Writing the Output to a CSV File
  dir = paste0("merged_data")
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  write.csv(all_data, "merged_data/raw-data.csv")
}

# Excuting the function
makeDat()

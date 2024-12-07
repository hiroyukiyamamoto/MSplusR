rm(list=ls(all=TRUE))

library(MSnbase)
mzfile <- "C:/Users/yamamoto/Documents/R/MSinfoR/Posi_Ida_Chlamydomonas_1.mzML"

x <- readMSData(mzfile, mode = "onDisk")
L <- header(x)
index2 <- which(L$msLevel==2)
x2 <- x[index2] # MS2のみ取得

premz0 <- L$precursorMZ[index2]

premz <- NULL;z <- NULL;k <- 1
for(i in 1:length(x2)){
  if (x2[[i]]@peaksCount>0){
    premz[k] <- premz0[i]
    z[[k]] <- x2[[i]]
    k <- k+1
  }
}

ss <- z

# -----------------------

mzrange <- seq(from = 100, to = 1250, by = 0.01) 

X <- matrix(NA,length(ss),length(mzrange)-1)
for(i in 1:length(ss)){
  print(i)
  spectrum2_obj <- ss[[i]]
  binned_spectrum <- bin(spectrum2_obj, breaks = mzrange)
  X[i,] <- binned_spectrum@intensity
}
X0 <- X

colnames(X0) <- paste0(mzrange[-length(mzrange)], "-", mzrange[-1])
rownames(X0) <- premz

save(X0, file="C:/R/Posi_Ida_Chlamydomonas_1_spec.rds")
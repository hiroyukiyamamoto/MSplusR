rm(list=ls(all=TRUE))

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")

### filtering

X <- X0
X[X<1000] <- 0 # intensityが1000以下のものは削除
X[X>0] <- 1 # intensityに値が入っているときには1にする

### generating similarity matrix

Z <- X%*%t(X) # 共通ピーク数の類似度行列

save(Z, file="C:/R/Z_common.rds")


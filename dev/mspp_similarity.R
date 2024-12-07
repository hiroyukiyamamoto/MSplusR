rm(list=ls(all=TRUE))

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")

### filtering

X <- X0

X[X<1000] <- 0 # intensityが1000以下のものは削除(ノイズ削除)

for(i in 1:nrow(X)){
  x <- X[i,]
  max_val <- max(x)
  if (max_val > 0) {
    x <- x / max_val
  }
  x[x<0.01] <- 0 # 1%未満のintensityは0にする
  X[i,] <- x
}
X[X>0] <- 1 # intensityに値が入っているときには1にする

### generating similarity matrix

library(Matrix)

X_sparse <- Matrix(X, sparse = TRUE)
Z_sparse <- X_sparse %*% t(X_sparse)
Z <- as.matrix(Z_sparse)
# Z <- X%*%t(X) # 共通ピーク数の類似度行列

save(Z, file="C:/R/Z_common.rds")


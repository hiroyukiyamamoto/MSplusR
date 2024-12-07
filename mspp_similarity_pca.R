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

save(X, file="C:/R/X_pca.rds")


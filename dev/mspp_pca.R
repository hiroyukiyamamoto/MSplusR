rm(list=ls(all=TRUE))

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")
load(file="C:/R/X_pca.rds")

index_spec <- which(apply(X,1,max)!=0) # 値が全部0のスペクトルを除く
X <- X[index_spec,]

### PCA

index0 <- which(apply(X,2,sd)!=0)
TT <- X[,index0]

library(irlba)
result <- irlba(scale(TT), nv = 10)

v <- scale(TT) %*% result$v
plot(v, pch=16, cex=1)

library(uwot)

umap_result <- umap(v[,c(1:10)])
plot(umap_result, pch=16, cex=0.5)

# 使用したスペクトルデータをサブセット化
subset_spectra <- X0[index_spec,]

# UMAP結果とスペクトルデータを保存
save(umap_result, file="C:/R/umap_pca.rds")
save(subset_spectra, file = "C:/R/subset_spectra_pca.rds")  # サブセット化したスペクトル

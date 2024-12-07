### グラフ隣接行列を使う場合
rm(list=ls(all=TRUE))

library(uwot)

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")
load(file="C:/R/Z_common.rds")

# graph neighbor matrix
diag(Z) <- 0 # 対角成分を0

W <- Z 
W[W<3] <- 0 # 共通ピークが3つ未満の場合は繋げない
W[W>0] <- 1 # 共通ピークの有無に変更

N <- as.numeric(apply(W,2,sum))
index <- which(N!=0) # 1つも繋がらないものは除外

### eigenvector

q <- svd(W[index,index])
umap_result <- umap(q$v[,c(1:10)])

# 使用したスペクトルデータをサブセット化
subset_spectra <- X0[index,]

# UMAP結果とスペクトルデータを保存
save(umap_result, file = "C:/R/umap_graph.rds")  # UMAP結果
save(subset_spectra, file = "C:/R/subset_spectra.rds")  # サブセット化したスペクトル
### グラフ隣接行列を使う場合
rm(list=ls(all=TRUE))

library(igraph)

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")

# ---  filtering ---------
X <- X0
X[X<1000] <- 0 # intensityが1000以下のものは削除
# 可能であれば、最初のスペクトルの時点でこの処理をしておく

X[X>0] <- 1 # intensityに値が入っているときには1にする

# --- generating matrix -------

# commom peak number matrix Z
Z <- X%*%t(X) 

# graph neibour matrix
diag(Z) <- 0 # 共通ピーク数行列
W <- Z 
W[W<3] <- 0 # 共通ピークが3つ未満の場合は繋げない
W[W>0] <- 1

# filtering
N <- as.numeric(apply(W,2,sum))
index <- which(N!=0)

#degree_values <- degree(g)
#g_filtered <- delete.vertices(g, which(degree_values == 0))

# --- eigenvector --------

q <- svd(W[index,index])
umap_result <- umap(q$v[,c(1:10)])

#plot(umap_result, pch=16, cex=0.5)

# --- clustering -----

# グラフオブジェクトを作成
g <- graph.adjacency(W[index,index], mode = "undirected", diag = FALSE)

# 連結成分を抽出
components <- components(g)

# クラスター番号を取得
cluster_numbers <- components$membership

# ---- plot -----------

# UMAPプロット
plot(umap_result,
     pch = pch_cluster,
     cex = 0.5,
     col = cluster_numbers,  # 中抜き色
     #     bg = cluster_numbers,      # 塗りつぶし色
     main = "UMAP with Enhanced Distinction",
     xlab = "UMAP1",
     ylab = "UMAP2")

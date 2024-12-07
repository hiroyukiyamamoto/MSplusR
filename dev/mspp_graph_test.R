### グラフ隣接行列を使う場合
rm(list=ls(all=TRUE))

library(igraph)

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

plot(umap_result, pch=16, cex=0.5)

save(umap_result, file="C:/R/umap_graph.rds")

# --- clustering -----

# グラフオブジェクトを作成
g <- graph.adjacency(W[index,index], mode = "undirected", diag = FALSE)

# 連結成分を抽出
components <- components(g)

# クラスター番号を取得
cluster_numbers <- components$membership

# ---- plot -----------

# クラスターごとの色を定義
cluster_numbers <- components$membership
num_clusters <- length(unique(cluster_numbers))

# 色の定義
colors <- rainbow(num_clusters)

# 点の形を定義 (Rではpchは0～25の範囲)
shapes <- rep(c(0:25), length.out = num_clusters)

# プロット
plot(umap_result,
     cex = 1.5,
     pch = shapes[cluster_numbers],  # クラスターごとに点の形
     col = colors[cluster_numbers], # 中抜き色
     bg = colors[cluster_numbers],  # 塗りつぶし色
     main = "UMAP with Enhanced Distinction",
     xlab = "UMAP1",
     ylab = "UMAP2",
     xlim=c(-5,5),
     ylim=c(0,10))


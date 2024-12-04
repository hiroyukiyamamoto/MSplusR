rm(list=ls(all=TRUE))

load(file="C:/Users/hyama/Documents/MSplusR/Posi_Ida_Chlamydomonas_1_spec.rds")

X <- X0
X[X<1000] <- 0 # intensityが1000以下のものは削除
# 可能であれば、最初のスペクトルの時点でこの処理をしておく

X[X>0] <- 1 # intensityに値が入っているときには、
Z <- X%*%t(X) # 共通ピーク数行列

diag(Z) <- 0 # 共通ピーク数行列

W <- Z 
W[W<3] <- 0 # 共通ピークが3つ未満の場合は繋げない(3～10に限定)
W[W>0] <- 1

N <- as.numeric(apply(W,2,sum))
index <- which(N!=0)

TT <- X[index,]

index0 <- which(apply(TT,2,sd)!=0)
TT <- TT[,index0]

library(irlba)
result <- irlba(scale(TT), nv = 10)

v <- scale(TT) %*% result$v
plot(v, pch=16, cex=1)

umap_result <- umap(v[,c(1:10)])
plot(umap_result, pch=16, cex=0.5)

# ------------------------------

q <- svd(W[index,index])
umap_result <- umap(q$v[,c(1:10)])

plot(umap_result, pch=16, cex=0.5)

# ------------------------------

# 階層的クラスタリングの実行
WW <- W[index,index]
diag(WW) <- 1
row_hclust <- hclust(as.dist(1-WW), "average")  # 行のクラスタリング
cluster_numbers <- cutree(row_hclust, k = 30)

#umap_result <- umap(v)

# ----------------------------------------

# ライブラリの読み込み
library(RColorBrewer)

# クラスター数の設定
n_clusters <- max(cluster_numbers)

# カラーパレットの準備
base_colors <- brewer.pal(12, "Set3")
fill_colors <- colorRampPalette(base_colors)(n_clusters)  # 塗りつぶし色
outline_colors <- rainbow(n_clusters)  # 中抜きの色

# プロット記号を循環的に設定
pch_values <- c(21, 22, 23, 24, 25)  # 丸、三角、四角、菱形、逆三角形
pch_cluster <- pch_values[(cluster_numbers - 1) %% length(pch_values) + 1]

# UMAPプロット
plot(umap_result,
     pch = pch_cluster,
     cex = 0.5,
     col = cluster_numbers,  # 中抜き色
#     bg = cluster_numbers,      # 塗りつぶし色
     main = "UMAP with Enhanced Distinction",
     xlab = "UMAP1",
     ylab = "UMAP2")


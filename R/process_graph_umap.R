process_graph_umap <- function(input_spectrum_file, input_similarity_file, 
                               output_umap_file = "umap_graph.rds", 
                               output_subset_file = "subset_spectra.rds", 
                               min_peaks = 3, n_components = 10) {
  # 必要なパッケージをロード
  if (!requireNamespace("uwot", quietly = TRUE)) {
    stop("The 'uwot' package is required. Please install it.")
  }
  library(uwot)
  
  # 入力ファイルをロード
  if (!file.exists(input_spectrum_file) || !file.exists(input_similarity_file)) {
    stop("指定された入力ファイルが存在しません。")
  }
  
  load(file = input_spectrum_file)  # スペクトルデータ
  load(file = input_similarity_file)  # 類似度行列
  
  if (!exists("X0") || !exists("Z")) {
    stop("入力ファイルに 'X0' または 'Z' オブジェクトが含まれていません。")
  }
  
  # グラフ隣接行列を作成
  diag(Z) <- 0  # 対角成分を0に
  W <- Z
  W[W < min_peaks] <- 0  # 共通ピーク数が min_peaks 未満の場合は接続を削除
  W[W > 0] <- 1  # 接続の有無をバイナリに変更
  
  # 接続がないノードを除外
  N <- as.numeric(apply(W, 2, sum))
  index <- which(N != 0)  # 接続があるノードのインデックスを取得
  
  # 固有ベクトルを計算
  q <- svd(W[index, index])
  
  # UMAPによる次元削減
  umap_result <- umap(q$v[, seq_len(n_components)])
  
  # サブセット化したスペクトルデータ
  subset_spectra <- X0[index, ]
  
  # 結果を保存
  save(umap_result, file = output_umap_file)  # UMAP結果
  save(subset_spectra, file = output_subset_file)  # サブセット化したスペクトル
  
  message("UMAP結果を保存しました: ", output_umap_file)
  message("サブセット化したスペクトルを保存しました: ", output_subset_file)
  
  return(list(umap_result = umap_result, subset_spectra = subset_spectra))
}

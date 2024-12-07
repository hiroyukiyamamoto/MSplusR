pca_umap_analysis <- function(input_spectrum_file, input_filtered_file, 
                              output_umap_file = "umap_pca.rds", 
                              output_subset_file = "subset_spectra_pca.rds", 
                              pca_components = 10) {
  # 必要なパッケージをロード
  if (!requireNamespace("irlba", quietly = TRUE) || !requireNamespace("uwot", quietly = TRUE)) {
    stop("The 'irlba' and 'uwot' packages are required. Please install them.")
  }
  library(irlba)
  library(uwot)
  
  # 入力データをロード
  if (!file.exists(input_spectrum_file) || !file.exists(input_filtered_file)) {
    stop("指定された入力ファイルが存在しません。")
  }
  
  load(file = input_spectrum_file)  # スペクトルデータ
  load(file = input_filtered_file)  # フィルタリング済みデータ
  
  if (!exists("X0") || !exists("X")) {
    stop("入力ファイルに 'X0' または 'X' オブジェクトが含まれていません。")
  }
  
  # 値がすべて0のスペクトルを除外
  index_spec <- which(apply(X, 1, max) != 0)
  X <- X[index_spec, ]
  
  # PCAの準備: 標準偏差が0でない列を抽出
  index0 <- which(apply(X, 2, sd) != 0)
  TT <- X[, index0]
  
  # PCAの計算
  pca_result <- irlba(scale(TT), nv = pca_components)
  
  # PCAのスコア
  v <- scale(TT) %*% pca_result$v
  
  # UMAP次元削減
  umap_result <- umap(v[, seq_len(pca_components)])
  
  # 使用したスペクトルデータをサブセット化
  subset_spectra <- X0[index_spec, ]
  
  # 結果を保存
  save(umap_result, file = output_umap_file)
  save(subset_spectra, file = output_subset_file)
  
  # メッセージを出力
  message("UMAP結果を保存しました：", output_umap_file)
  message("サブセット化したスペクトルデータを保存しました：", output_subset_file)
  
  # 結果を返す
  return(list(umap_result = umap_result, subset_spectra = subset_spectra))
}

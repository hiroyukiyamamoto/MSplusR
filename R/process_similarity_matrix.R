process_similarity_matrix <- function(input_file, 
                                      output_file = "Z_common.rds", 
                                      intensity_threshold = 1000, 
                                      normalization_threshold = 0.01) {
  # 必要なパッケージをロード
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    stop("The 'Matrix' package is required. Please install it.")
  }
  library(Matrix)
  
  # 入力データのロード
  if (!file.exists(input_file)) {
    stop("指定された入力ファイルが存在しません：", input_file)
  }
  load(file = input_file)  # 入力ファイルは 'X0' を含むものとする
  
  if (!exists("X0")) {
    stop("入力ファイル内に 'X0' オブジェクトが見つかりません。")
  }
  
  X <- X0
  
  # フィルタリング処理
  X[X < intensity_threshold] <- 0  # ノイズ削除
  
  for (i in 1:nrow(X)) {
    x <- X[i, ]
    max_val <- max(x)
    if (max_val > 0) {
      x <- x / max_val  # 最大値で正規化
    }
    x[x < normalization_threshold] <- 0  # 1%未満を0に
    X[i, ] <- x
  }
  
  X[X > 0] <- 1  # 非ゼロ要素を1に置換
  
  # 類似度行列の計算
  X_sparse <- Matrix(X, sparse = TRUE)
  Z_sparse <- X_sparse %*% t(X_sparse)  # 共通ピーク数の類似度行列
  Z <- as.matrix(Z_sparse)
  
  # 結果を保存
  save(Z, file = output_file)
  message("類似度行列を計算し、以下のファイルに保存しました：", output_file)
  
  return(Z)
}
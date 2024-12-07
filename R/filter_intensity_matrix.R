filter_intensity_matrix <- function(input_file, output_file = "X_filtered.rds", 
                                    intensity_threshold = 1000, normalization_threshold = 0.01) {
  # ファイルの存在を確認
  if (!file.exists(input_file)) {
    stop("指定された入力ファイルが存在しません：", input_file)
  }
  
  # 入力データをロード
  load(file = input_file)  # 'X0' が含まれていると想定
  
  if (!exists("X0")) {
    stop("入力ファイルに 'X0' オブジェクトが含まれていません。")
  }
  
  # データフィルタリング
  X <- X0
  
  # intensityが閾値以下のものを0にする（ノイズ削除）
  X[X < intensity_threshold] <- 0
  
  # 各行を処理
  for (i in 1:nrow(X)) {
    x <- X[i, ]
    max_val <- max(x)
    if (max_val > 0) {
      x <- x / max_val  # 最大値で正規化
    }
    x[x < normalization_threshold] <- 0  # 閾値以下を0にする
    X[i, ] <- x
  }
  
  # 非ゼロ値を1に置き換え
  X[X > 0] <- 1
  
  # 結果を保存
  save(X, file = output_file)
  message("フィルタリング後のデータを保存しました：", output_file)
  
  return(X)
}

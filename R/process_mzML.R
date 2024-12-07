process_mzML <- function(mzfile, 
                         mzrange = NULL, 
                         bin_width = 0.01, 
                         output_file = "processed_spectrum.rds") {
  # 入力ファイルが存在するか確認
  if (!file.exists(mzfile)) {
    stop("指定されたmzMLファイルが存在しません：", mzfile)
  }
  
  # MSnbaseでデータを読み込む
  x <- readMSData(mzfile, mode = "onDisk")
  L <- header(x)
  
  # MS2のみ抽出
  index2 <- which(L$msLevel == 2)
  if (length(index2) == 0) {
    stop("MS2スペクトルが見つかりません。")
  }
  x2 <- x[index2]
  
  # デフォルトmzrangeを計算
  if (is.null(mzrange)) {
    # スペクトル全体からm/z範囲を計算
    mz_values <- unlist(lapply(spectra(x2), function(spectrum) spectrum@mz), use.names = FALSE)
    min_mz <- floor(min(mz_values))
    max_mz <- ceiling(max(mz_values))
    mzrange <- seq(from = min_mz, to = max_mz, by = bin_width)
    message("mzrangeを自動計算しました：", min_mz, " ~ ", max_mz)
  }
  
  premz0 <- L$precursorMZ[index2]
  premz <- NULL
  z <- list()
  k <- 1
  
  # MS2のスペクトルを抽出
  for (i in seq_along(x2)) {
    spectrum <- spectra(x2)[[i]]
    if (length(spectrum@mz) > 0) {
      premz[k] <- premz0[i]
      z[[k]] <- spectrum
      k <- k + 1
    }
  }
  
  ss <- z
  
  # スペクトルをビニングしてマトリックスに変換
  X <- matrix(NA, length(ss), length(mzrange) - 1)
  for (i in seq_along(ss)) {
    spectrum2_obj <- ss[[i]]
    binned_spectrum <- bin(spectrum2_obj, breaks = mzrange)
    X[i, ] <- binned_spectrum@intensity
  }
  X0 <- X
  
  # 行列にラベルを付与
  colnames(X0) <- paste0(mzrange[-length(mzrange)], "-", mzrange[-1])
  rownames(X0) <- premz
  
  # ファイルに保存
  save(X0, file = output_file)
  message("処理が完了しました。結果は以下のファイルに保存されました：", output_file)
  
  return(X0)
}

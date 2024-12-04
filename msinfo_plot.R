# サンプルデータ
set.seed(123)
samples <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  sample_id = 1:100
)

# MS/MSスペクトルデータを生成する関数
generate_spectrum <- function(sample_id) {
  set.seed(sample_id)
  data.frame(
    mz = seq(50, 500, length.out = 100),  # m/z範囲
    intensity = abs(rnorm(100, mean = 100, sd = 30))  # 強度
  )
}

# 散布図をRの標準プロットで描画
plot(samples$x, samples$y, pch = 16, col = "blue",
     xlab = "X-axis", ylab = "Y-axis", main = "Click on points to see spectra")

# 複数ポイントをクリックしてサンプルIDを取得
cat("サンプルをクリックしてください（終了するには右クリックまたはEscキー）...\n")
selected_points <- identify(samples$x, samples$y, labels = samples$sample_id, plot = FALSE)

# 取得したポイントに基づいてスペクトルを描画
for (sample_id in selected_points) {
  # 新しいウィンドウでMS/MSスペクトルを描画
  dev.new()
  spectrum <- generate_spectrum(sample_id)
  plot(
    spectrum$mz, spectrum$intensity, type = "h", col = "red",
    xlab = "m/z", ylab = "Intensity",
    main = paste("MS/MS Spectrum for Sample", sample_id)
  )
}
cat("スペクトルプロットが完了しました。\n")

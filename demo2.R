library(MSplusR)

# ファイルパスを取得
file_path <- system.file("extdata", "Posi_Ida_Chlamydomonas_1_spec.rds", package = "MSplusR")

# データを読み込む
load(file_path)

# データ準備
output_file <- "filtered_data.rds"  # 保存先のファイルパス
result <- filter_intensity_matrix(
  input_file = file_path,
  output_file = output_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01
)

# UMAPの計算
input_spectrum_file <- file_path
input_filtered_file <- output_file  # フィルタリング後のデータ
output_umap_file <- "umap_result.rds"  # UMAP結果の保存先
output_subset_file <- "subset_result.rds"  # サブセット保存先

result <- pca_umap_analysis(
  input_spectrum_file = input_spectrum_file,
  input_filtered_file = input_filtered_file,
  output_umap_file = output_umap_file,
  output_subset_file = output_subset_file,
  pca_components = 10
)

# 結果の可視化
# Launch the Shiny application
library(plotly)

spectra_file <- file_path  # スペクトルファイルを指定
create_shiny_umap_viewer(
  umap_file = umap_file,
  spectra_file = subset_file,
  app_title = "UMAP Viewer Example"
)

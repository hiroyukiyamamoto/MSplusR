library(MSplusR)

# ファイルパスを取得
file_path <- system.file("extdata", "Posi_Ida_Chlamydomonas_1_spec.rds", package = "MSplusR")

# データを読み込む
load(file_path)

# 類似度行列の計算
similarity_file <- "similarity_matrix.rds"
result <- process_similarity_matrix(
  input_file = file_path,
  output_file = similarity_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01
)

# UMAPの計算
umap_file <- "umap_result.rds"  # UMAP結果の出力ファイルパス
subset_file <- "subset_result.rds"  # サブセットの出力ファイルパス
result <- process_graph_umap(
  input_spectrum_file = file_path,
  input_similarity_file = similarity_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  min_peaks = 3,
  n_components = 10
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

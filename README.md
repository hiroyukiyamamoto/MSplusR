# MSplusR

`MSplusR` は、質量分析スペクトルデータの前処理、次元圧縮、可視化、Mass++ 連携を行うための R パッケージです。  
MS/MS スペクトルを R で扱いやすい形に整え、`PCA + UMAP` 系と `similarity / graph UMAP` 系の両方を試せるようにしています。

## 主な機能

- スペクトル前処理
  - 強度閾値処理
  - base peak 正規化
  - 二値化 (`0/1`)
  - `IDF-only` 重み付け
- 次元圧縮
  - `PCA + UMAP`
  - 類似度行列からの `graph UMAP`
- 可視化
  - `shiny + plotly` による UMAP viewer
- Mass++ 連携
  - Mass++ API を使ったセッション作成
  - 単一スペクトル送信

## インストール

ローカルの source package から入れる例です。

```r
install.packages("MSplusR_0.1.5.tar.gz", repos = NULL, type = "source")
```

依存パッケージが不足する場合は、先に入れてください。

```r
install.packages(
  c("uwot", "irlba", "shiny", "plotly", "httr", "jsonlite", "igraph"),
  repos = "https://cloud.r-project.org"
)
```

## まず試すなら

`library(MSplusR)` のあと、まずはラッパー関数を使うのがいちばん簡単です。

### 1. 推奨ルート: `IDF-only + PCA + UMAP`

```r
library(MSplusR)

run_pca_umap_workflow(
  weighting_method = "idf_only",
  scaling = FALSE,
  centering = TRUE
)
```

### 1b. Mass++ 連携ルート: `IDF-only + PCA + UMAP`

```r
library(MSplusR)

run_pca_umap_masspp_workflow(
  weighting_method = "idf_only",
  scaling = FALSE,
  centering = TRUE
)
```

### 2. 類似度行列ルート: `IDF-only + similarity matrix + graph UMAP`

```r
library(MSplusR)

run_similarity_graph_umap_workflow(
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)
```

### 2b. Mass++ 連携ルート: `IDF-only + similarity matrix + graph UMAP`

```r
library(MSplusR)

run_similarity_graph_umap_masspp_workflow(
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)
```

どちらも、デフォルトでは同梱データ

```r
system.file("extdata", "Posi_Ida_Chlamydomonas_1_spec.rds", package = "MSplusR")
```

を使うので、追加データなしでそのまま試せます。

## 基本的な使い方

### 1. `IDF-only + PCA + UMAP`

```r
library(MSplusR)

spectra_file <- system.file(
  "extdata",
  "Posi_Ida_Chlamydomonas_1_spec.rds",
  package = "MSplusR"
)

filtered_file <- tempfile(fileext = ".rds")
umap_file <- tempfile(fileext = ".rds")
subset_file <- tempfile(fileext = ".rds")

filter_intensity_matrix(
  input_file = spectra_file,
  output_file = filtered_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = "idf_only"
)

pca_umap_analysis(
  input_spectrum_file = spectra_file,
  input_filtered_file = filtered_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE
)

create_shiny_umap_viewer(
  umap_file = umap_file,
  spectra_file = subset_file,
  app_title = "MSplusR: IDF-only + PCA + UMAP"
)
```

### 2. `IDF-only + similarity matrix + graph UMAP`

```r
library(MSplusR)

spectra_file <- system.file(
  "extdata",
  "Posi_Ida_Chlamydomonas_1_spec.rds",
  package = "MSplusR"
)

similarity_file <- tempfile(fileext = ".rds")
umap_file <- tempfile(fileext = ".rds")
subset_file <- tempfile(fileext = ".rds")

process_similarity_matrix(
  input_file = spectra_file,
  output_file = similarity_file,
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = "idf_only",
  similarity_method = "common_peaks"
)

process_graph_umap(
  input_spectrum_file = spectra_file,
  input_similarity_file = similarity_file,
  output_umap_file = umap_file,
  output_subset_file = subset_file,
  min_peaks = 3,
  n_components = 10
)

create_shiny_umap_viewer(
  umap_file = umap_file,
  spectra_file = subset_file,
  app_title = "MSplusR: IDF-only + similarity matrix + graph UMAP"
)
```

## Mass++ 連携

Mass++ が `http://localhost:8191/` で起動している場合、パッケージ関数から API を呼べます。

### セッション作成

```r
library(MSplusR)

session_id <- create_masspp_session()
session_id
```

### 単一スペクトル送信

```r
library(MSplusR)

send_scan_to_masspp(
  mz = c(100.0, 150.0, 200.0),
  intensity = c(1000, 500, 250),
  ms_level = 2,
  precursor_mz = 300.1234,
  rt = 123.4
)
```

## ラッパー関数

- `run_pca_umap_workflow()`
  - `filter_intensity_matrix()`
  - `pca_umap_analysis()`
  - `create_shiny_umap_viewer()`
  をまとめて実行
- `run_similarity_graph_umap_workflow()`
  - `process_similarity_matrix()`
  - `process_graph_umap()`
  - `create_shiny_umap_viewer()`
  をまとめて実行
- `run_pca_umap_masspp_workflow()`
  - `filter_intensity_matrix()`
  - `pca_umap_analysis()`
  - `create_masspp_umap_viewer()`
  をまとめて実行
- `run_similarity_graph_umap_masspp_workflow()`
  - `process_similarity_matrix()`
  - `process_graph_umap()`
  - `create_masspp_umap_viewer()`
  をまとめて実行


## 主な関数

- `filter_intensity_matrix()`
  - スペクトル前処理
- `pca_umap_analysis()`
  - PCA と UMAP
- `process_similarity_matrix()`
  - 類似度行列作成
- `process_graph_umap()`
  - 類似度行列から graph UMAP
- `create_shiny_umap_viewer()`
  - UMAP viewer
- `create_masspp_session()`
  - Mass++ セッション作成
- `send_scan_to_masspp()`
  - 単一スペクトル送信

## 備考

- `PCA + UMAP` 側では、現時点の推奨条件として
  - `weighting_method = "idf_only"`
  - `scaling = FALSE`
  - `centering = TRUE`
  を想定しています。
- `similarity matrix` 側では、初期実装として
  - `similarity_method = "common_peaks"`
  を採用しています。

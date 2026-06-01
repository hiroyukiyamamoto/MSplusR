# demo

このフォルダは、`MSplusR` の図、`Mass++` 連携用スクリプト、そして実行に必要な最小データ一式をまとめたデモ用フォルダです。

## スクリプトと条件の対応

### 1. `prepare_deig_idfonly_viewer_cache.R`

役割:
- `deigidfonly_rel005_nc30_nn5_cluster_membership.csv` を使う
- `all_ms2_binned_0p010.rds` を使う
- 強度 `1000` cutoff
- base peak 正規化
- 相対強度 `5%` cutoff

出力:
- `Posi_Ida_Chlamydomonas_1_deigidfonly_viewer_cache.rds`

### 2. `deig_idfonly_presentation_plot.R`

役割:
- 距離行列側の主図を作る
  - `deigidfonly_rel005_nc30_nn5_same_ms1_top10_numbers_presentation.png`
- クリックしたスペクトルを `Mass++` に送る viewer を起動する

補足:
- script 内では `deigbin_rel005_nc30_nn5_cluster_membership.csv` も読みます
- これは比較図を再生成するためで、viewer の本体は `deigidfonly` 側です

### 3. `send_same_ms1_group_to_masspp.R`

役割:
- `deigidfonly` 側の membership と viewer cache を使って
- 指定した `xcms_peak_idx` の same-MS1 群を `Mass++` に一括送信する

初期設定:
- `target_xcms_peak_idx <- 2800`
- `send_mode <- "all"`

## まず何を実行するか

### 1. viewer cache を作る

```r
source("~/R/MSplusR_github/demo/prepare_deig_idfonly_viewer_cache.R")
```

### 2. 図を作る / Mass++ viewer を開く

```r
source("~/R/MSplusR_github/demo/deig_idfonly_presentation_plot.R")
```

このスクリプトで行うこと:
- 距離行列側 `deigidfonly` の PNG を出力
- `1〜10` の same-MS1 群を番号付きで表示
- Shiny viewer を起動
- viewer 上でクリックしたスペクトルを `Mass++` に送信

### 3. 特定の same-MS1 群を Mass++ に直接送る

```r
source("~/R/MSplusR_github/demo/send_same_ms1_group_to_masspp.R")
```

## 今フォルダに置いてある PNG

### スクリプトから直接再現できるもの

- `Posi_Ida_Chlamydomonas_1_deigidfonly_rel005_nc30_nn5_same_ms1_top10_numbers_presentation.png`

### 参考として置いてあるもの

- `Posi_Ida_Chlamydomonas_1_idfonly_pca030_nn5_md001_noscale_same_ms1_top10_numbers_presentation.png`

これは `IDF-only + PCA + UMAP + no autoscaling` の参考図で、今の `demo` フォルダ内 script からは再生成しません。

## 含まれているデータ

- `Posi_Ida_Chlamydomonas_1/`
  - viewer cache 作成と presentation script 実行に必要な benchmark データ

## 前提

- `Mass++` を使う場合は、`Mass++` を先に起動しておく
- `Mass++` API は `http://localhost:8191/` で受ける想定

## 補足

- `deig_idfonly_presentation_plot.R` は、`1〜10` の番号付き same-MS1 群を表示するスクリプトです
- `prepare_deig_idfonly_viewer_cache.R` を実行していないと、viewer 起動時に必要な cache がありません

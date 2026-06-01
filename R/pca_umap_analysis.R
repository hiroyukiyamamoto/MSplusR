pca_umap_analysis <- function(
  input_spectrum_file,
  input_filtered_file,
  output_umap_file = "umap_pca.rds",
  output_subset_file = "subset_spectra_pca.rds",
  pca_components = 10,
  umap_n_neighbors = 15,
  umap_min_dist = 0.01,
  scaling = FALSE,
  centering = TRUE
) {
  if (!requireNamespace("irlba", quietly = TRUE) ||
      !requireNamespace("uwot", quietly = TRUE)) {
    stop("The 'irlba' and 'uwot' packages are required. Please install them.")
  }
  library(irlba)
  library(uwot)

  if (!file.exists(input_spectrum_file) || !file.exists(input_filtered_file)) {
    stop("Required input files were not found.")
  }

  load(file = input_spectrum_file)
  load(file = input_filtered_file)

  if (!exists("X0") || !exists("X")) {
    stop("Objects 'X0' and 'X' must exist in the input files.")
  }

  index_spec <- which(apply(X, 1, max) != 0)
  X_sub <- X[index_spec, , drop = FALSE]

  index0 <- which(apply(X_sub, 2, sd) != 0)
  TT <- X_sub[, index0, drop = FALSE]

  if (!isTRUE(centering) && !isTRUE(scaling)) {
    TT_pca <- TT
  } else {
    TT_pca <- scale(TT, center = centering, scale = scaling)
  }

  max_rank <- min(nrow(TT_pca), ncol(TT_pca))
  if (max_rank < 2) {
    stop("At least two rows/columns with variation are required for PCA.")
  }

  n_pcs <- min(pca_components, max_rank - 1)
  pca_result <- irlba(TT_pca, nv = n_pcs)
  v <- TT_pca %*% pca_result$v

  umap_result <- umap(
    v[, seq_len(n_pcs), drop = FALSE],
    n_neighbors = umap_n_neighbors,
    min_dist = umap_min_dist
  )

  subset_spectra <- X0[index_spec, , drop = FALSE]

  scaling_used <- scaling
  centering_used <- centering
  pca_components_used <- n_pcs
  umap_n_neighbors_used <- umap_n_neighbors
  umap_min_dist_used <- umap_min_dist

  save(
    umap_result,
    scaling_used,
    centering_used,
    pca_components_used,
    umap_n_neighbors_used,
    umap_min_dist_used,
    file = output_umap_file
  )
  save(
    subset_spectra,
    index_spec,
    index0,
    file = output_subset_file
  )

  message("Saved UMAP result: ", output_umap_file)
  message("Saved subset spectra: ", output_subset_file)

  list(
    umap_result = umap_result,
    subset_spectra = subset_spectra,
    pca_scores = v,
    settings = list(
      scaling = scaling,
      centering = centering,
      pca_components = n_pcs,
      umap_n_neighbors = umap_n_neighbors,
      umap_min_dist = umap_min_dist
    )
  )
}

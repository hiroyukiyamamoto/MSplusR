process_similarity_matrix <- function(
  input_file,
  output_file = "Z_common.rds",
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  weighting_method = c("none", "idf_only"),
  similarity_method = c("cosine", "common_peaks")
) {
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    stop("The 'Matrix' package is required. Please install it.")
  }
  library(Matrix)

  weighting_method <- match.arg(weighting_method)
  similarity_method <- match.arg(similarity_method)

  if (!file.exists(input_file)) {
    stop("Input file was not found: ", input_file)
  }

  load(file = input_file)

  if (!exists("X0")) {
    stop("Object 'X0' was not found in the input file.")
  }

  X <- X0
  X[X < intensity_threshold] <- 0

  for (i in seq_len(nrow(X))) {
    xi <- X[i, ]
    max_val <- max(xi)
    if (max_val > 0) {
      xi <- xi / max_val
    }
    xi[xi < normalization_threshold] <- 0
    X[i, ] <- xi
  }

  X[X > 0] <- 1

  df <- NULL
  idf <- NULL
  if (identical(weighting_method, "idf_only")) {
    df <- colSums(X > 0)
    idf <- log((nrow(X) + 1) / (df + 1)) + 1
    X <- sweep(X, 2, idf, `*`)
  }

  X_sparse <- Matrix(X, sparse = TRUE)

  if (identical(similarity_method, "common_peaks")) {
    Z_sparse <- X_sparse %*% t(X_sparse)
  } else {
    row_norms <- sqrt(Matrix::rowSums(X_sparse ^ 2))
    row_norms[row_norms == 0] <- 1
    X_norm <- X_sparse / row_norms
    Z_sparse <- X_norm %*% t(X_norm)
  }

  Z <- as.matrix(Z_sparse)

  weighting_method_used <- weighting_method
  similarity_method_used <- similarity_method
  intensity_threshold_used <- intensity_threshold
  normalization_threshold_used <- normalization_threshold

  if (is.null(df)) {
    save(
      Z,
      weighting_method_used,
      similarity_method_used,
      intensity_threshold_used,
      normalization_threshold_used,
      file = output_file
    )
  } else {
    save(
      Z,
      df,
      idf,
      weighting_method_used,
      similarity_method_used,
      intensity_threshold_used,
      normalization_threshold_used,
      file = output_file
    )
  }

  message("Saved similarity matrix: ", output_file)
  Z
}

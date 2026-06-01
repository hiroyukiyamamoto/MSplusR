filter_intensity_matrix <- function(
  input_file,
  output_file = "X_filtered.rds",
  intensity_threshold = 1000,
  normalization_threshold = 0.01,
  binarize = TRUE,
  weighting_method = c("none", "idf_only"),
  return_idf = FALSE
) {
  weighting_method <- match.arg(weighting_method)

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

  if (isTRUE(binarize)) {
    X[X > 0] <- 1
  }

  df <- NULL
  idf <- NULL
  if (identical(weighting_method, "idf_only")) {
    df <- colSums(X > 0)
    idf <- log((nrow(X) + 1) / (df + 1)) + 1
    X <- sweep(X, 2, idf, `*`)
  }

  weighting_method_used <- weighting_method
  intensity_threshold_used <- intensity_threshold
  normalization_threshold_used <- normalization_threshold
  binarize_used <- binarize

  if (is.null(df)) {
    save(
      X,
      weighting_method_used,
      intensity_threshold_used,
      normalization_threshold_used,
      binarize_used,
      file = output_file
    )
  } else {
    save(
      X,
      df,
      idf,
      weighting_method_used,
      intensity_threshold_used,
      normalization_threshold_used,
      binarize_used,
      file = output_file
    )
  }

  message("Saved filtered matrix: ", output_file)

  if (isTRUE(return_idf)) {
    return(list(
      X = X,
      df = df,
      idf = idf,
      weighting_method = weighting_method
    ))
  }

  X
}

suppressPackageStartupMessages({
  library(MSnbase)
})

sample_name <- "Posi_Ida_Chlamydomonas_1"

get_script_path <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- "--file="
  path <- sub(file_arg, "", cmd_args[grep(file_arg, cmd_args)])
  if (length(path) > 0) {
    return(normalizePath(path[1], winslash = "/", mustWork = TRUE))
  }
  if (!is.null(sys.frames()[[1]]$ofile)) {
    return(normalizePath(sys.frames()[[1]]$ofile, winslash = "/", mustWork = TRUE))
  }
  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

script_dir <- dirname(get_script_path())
project_root <- if (basename(script_dir) == "presentation") dirname(script_dir) else dirname(script_dir)
presentation_dir <- script_dir
base_dir <- file.path(script_dir, sample_name)
config_dir_idf <- file.path(base_dir, "benchmark_distance_eigen_idfonly_configs")

membership_file <- file.path(config_dir_idf, "deigidfonly_rel005_nc30_nn5_cluster_membership.csv")
binned_cache_file <- file.path(base_dir, "all_ms2_binned_0p010.rds")
all_metadata_file <- file.path(base_dir, paste0(sample_name, "_allms2_pca_bin005_seed123_metadata.csv"))
viewer_cache_file <- file.path(presentation_dir, paste0(sample_name, "_deigidfonly_viewer_cache.rds"))

required_files <- c(membership_file, binned_cache_file, all_metadata_file)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop("Required files were not found: ", paste(missing_files, collapse = ", "))
}

idf_df <- read.csv(membership_file, stringsAsFactors = FALSE)
all_metadata <- read.csv(all_metadata_file, stringsAsFactors = FALSE)
X0 <- readRDS(binned_cache_file)
X <- X0
X[X < 1000] <- 0
for (i in seq_len(nrow(X))) {
  xi <- X[i, ]
  max_val <- max(xi)
  if (max_val > 0) xi <- xi / max_val
  xi[xi < 0.05] <- 0
  X[i, ] <- xi
}

match_idx <- match(idf_df$ms2_acquisition_num, all_metadata$ms2_acquisition_num)
if (any(is.na(match_idx))) {
  missing_acq <- idf_df$ms2_acquisition_num[is.na(match_idx)]
  stop("Could not map ms2_acquisition_num to all_metadata rows: ", paste(missing_acq, collapse = ", "))
}
subset_spectra <- X[match_idx, , drop = FALSE]
col_names <- colnames(subset_spectra)
mz_starts <- as.numeric(sub("-.*", "", col_names))
mz_ends <- as.numeric(sub(".*-", "", col_names))
mz_axis <- (mz_starts + mz_ends) / 2

saveRDS(
  list(
    subset_spectra = subset_spectra,
    mz_axis = mz_axis
  ),
  viewer_cache_file
)

message("Wrote viewer cache: ", viewer_cache_file)

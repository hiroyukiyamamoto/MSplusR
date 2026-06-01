suppressPackageStartupMessages({
  library(jsonlite)
  library(httr)
})

sample_name <- "Posi_Ida_Chlamydomonas_1"
target_xcms_peak_idx <- 2800
send_mode <- "all" # "single_first" or "all"
post_send_wait_sec <- 5
base_url <- "http://localhost:8191/"

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
viewer_cache_file <- file.path(
  presentation_dir,
  paste0(sample_name, "_deigidfonly_viewer_cache.rds")
)
membership_file <- file.path(
  base_dir,
  "benchmark_distance_eigen_idfonly_configs",
  "deigidfonly_rel005_nc30_nn5_cluster_membership.csv"
)

required_files <- c(viewer_cache_file, membership_file)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop("Required files were not found: ", paste(missing_files, collapse = ", "))
}

parse_maybe_json <- function(x) {
  if (is.null(x) || !is.character(x) || length(x) != 1) {
    return(x)
  }
  txt <- trimws(x)
  if (!(startsWith(txt, "{") || startsWith(txt, "[") || startsWith(txt, "\""))) {
    return(x)
  }
  tryCatch(fromJSON(txt), error = function(e) x)
}

call_api <- function(endpoint, data = NULL) {
  url <- paste0(base_url, endpoint)
  body <- if (is.null(data)) "null" else toJSON(data, auto_unbox = TRUE)
  res <- httr::POST(
    url,
    body = body,
    encode = "raw",
    httr::add_headers("Content-Type" = "application/json")
  )
  txt <- httr::content(res, "text", encoding = "UTF-8")
  value <- if (!nzchar(txt)) NULL else tryCatch(fromJSON(txt), error = function(e) txt)
  value <- parse_maybe_json(value)
  list(status = httr::status_code(res), raw = txt, value = value)
}

extract_id <- function(resp) {
  x <- resp$value
  if (is.null(x)) {
    return(NULL)
  }
  if (is.list(x) && !is.null(x$id)) {
    return(as.character(x$id))
  }
  if (is.atomic(x) && length(x) == 1 && nzchar(as.character(x))) {
    return(as.character(x))
  }
  NULL
}

viewer_cache <- readRDS(viewer_cache_file)
subset_spectra <- viewer_cache$subset_spectra
mz_axis <- viewer_cache$mz_axis
viewer_df <- read.csv(membership_file, stringsAsFactors = FALSE)
rows <- which(viewer_df$xcms_peak_idx == target_xcms_peak_idx)

if (length(rows) == 0) {
  stop("No rows found for xcms_peak_idx = ", target_xcms_peak_idx)
}

rows_to_send <- switch(
  send_mode,
  single_first = rows[1],
  all = rows,
  stop("Unknown send_mode: ", send_mode)
)

session_res <- call_api("io_create_sample")
session_id <- extract_id(session_res)
cat("io_create_sample status:", session_res$status, "\n")
cat("io_create_sample raw:", session_res$raw, "\n")

if (is.null(session_id) || !nzchar(session_id)) {
  stop("Failed to create Mass++ sample session.")
}

cat("Mass++ session id:", session_id, "\n")
cat("Sending xcms_peak_idx:", target_xcms_peak_idx, "\n")
cat("Send mode:", send_mode, "\n")
cat("Number of spectra to send:", length(rows_to_send), "\n")

for (target_id in rows_to_send) {
  intensity_vec <- as.numeric(subset_spectra[target_id, ])
  valid_idx <- which(intensity_vec > 0)
  if (length(valid_idx) == 0) {
    cat("target row:", target_id, "has no peaks after filtering; skipped.\n")
    next
  }

  scan_data <- list(
    id = session_id,
    msLevel = 2,
    precursorMz = as.numeric(viewer_df$precursor_mz[target_id]),
    rt = as.numeric(viewer_df$ms2_retention_time[target_id]),
    points = data.frame(x = mz_axis[valid_idx], y = intensity_vec[valid_idx]),
    centroidMode = TRUE,
    minMz = mz_axis[min(valid_idx)] - 1,
    maxMz = mz_axis[max(valid_idx)] + 1
  )

  add_res <- call_api("io_add_scan", scan_data)
  flush_res <- call_api("io_flush", list(id = session_id, index = 0))

  cat(
    "row:", target_id,
    "| feature:", viewer_df$feature_id[target_id],
    "| acq:", viewer_df$ms2_acquisition_num[target_id],
    "| precursor:", sprintf("%.6f", as.numeric(viewer_df$precursor_mz[target_id])),
    "| rt:", sprintf("%.3f", as.numeric(viewer_df$ms2_retention_time[target_id])),
    "| add_status:", add_res$status,
    "| add_raw:", add_res$raw,
    "| flush_status:", flush_res$status,
    "| flush_raw:", flush_res$raw,
    "\n"
  )

  Sys.sleep(0.3)
}

cat("Finished sending xcms_peak_idx", target_xcms_peak_idx, "to Mass++.\n")
cat("Waiting", post_send_wait_sec, "seconds before exit...\n")
Sys.sleep(post_send_wait_sec)

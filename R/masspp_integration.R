create_masspp_session <- function(base_url = "http://localhost:8191/") {
  if (!requireNamespace("httr", quietly = TRUE) ||
      !requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The 'httr' and 'jsonlite' packages are required. Please install them.")
  }

  res <- .call_masspp_api(
    endpoint = "io_create_sample",
    data = NULL,
    base_url = base_url
  )

  session_id <- .extract_masspp_id(res)
  if (is.null(session_id) || !nzchar(session_id)) {
    stop("Failed to create a Mass++ sample session.")
  }

  session_id
}

send_scan_to_masspp <- function(
  mz,
  intensity,
  sample_id = NULL,
  base_url = "http://localhost:8191/",
  ms_level = 2,
  precursor_mz = -1,
  rt = 0,
  centroid_mode = TRUE,
  min_mz = NULL,
  max_mz = NULL,
  flush_index = 0,
  wait_sec = 0
) {
  if (!requireNamespace("httr", quietly = TRUE) ||
      !requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The 'httr' and 'jsonlite' packages are required. Please install them.")
  }

  mz <- as.numeric(mz)
  intensity <- as.numeric(intensity)

  if (length(mz) != length(intensity)) {
    stop("'mz' and 'intensity' must have the same length.")
  }

  keep <- is.finite(mz) & is.finite(intensity) & intensity > 0
  mz <- mz[keep]
  intensity <- intensity[keep]

  if (length(mz) == 0) {
    stop("No peaks with positive intensity were found.")
  }

  if (is.null(sample_id) || !nzchar(sample_id)) {
    sample_id <- create_masspp_session(base_url = base_url)
  }

  if (is.null(min_mz)) {
    min_mz <- min(mz) - 1
  }
  if (is.null(max_mz)) {
    max_mz <- max(mz) + 1
  }

  scan_data <- list(
    id = sample_id,
    msLevel = as.integer(ms_level),
    precursorMz = as.numeric(precursor_mz),
    rt = as.numeric(rt),
    points = data.frame(x = mz, y = intensity),
    centroidMode = isTRUE(centroid_mode),
    minMz = as.numeric(min_mz),
    maxMz = as.numeric(max_mz)
  )

  add_res <- .call_masspp_api(
    endpoint = "io_add_scan",
    data = scan_data,
    base_url = base_url
  )
  flush_res <- .call_masspp_api(
    endpoint = "io_flush",
    data = list(id = sample_id, index = as.integer(flush_index)),
    base_url = base_url
  )

  if (isTRUE(wait_sec > 0)) {
    Sys.sleep(wait_sec)
  }

  list(
    sample_id = sample_id,
    add_res = add_res,
    flush_res = flush_res
  )
}

.call_masspp_api <- function(endpoint, data = NULL, base_url = "http://localhost:8191/") {
  url <- paste0(base_url, endpoint)
  body <- if (is.null(data)) "null" else jsonlite::toJSON(data, auto_unbox = TRUE)
  res <- httr::POST(
    url,
    body = body,
    encode = "raw",
    httr::add_headers("Content-Type" = "application/json")
  )
  txt <- httr::content(res, "text", encoding = "UTF-8")
  value <- if (!nzchar(txt)) NULL else tryCatch(jsonlite::fromJSON(txt), error = function(e) txt)
  if (is.character(value) && length(value) == 1) {
    trimmed <- trimws(value)
    if (startsWith(trimmed, "{") || startsWith(trimmed, "[")) {
      value <- tryCatch(jsonlite::fromJSON(trimmed), error = function(e) value)
    }
  }
  list(status = httr::status_code(res), raw = txt, value = value)
}

.extract_masspp_id <- function(resp) {
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

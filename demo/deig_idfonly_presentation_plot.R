suppressPackageStartupMessages({
  library(shiny)
  library(plotly)
  library(httr)
  library(jsonlite)
})

sample_name <- "Posi_Ida_Chlamydomonas_1"
base_url <- "http://localhost:8191/"
launch_masspp_viewer <- TRUE
viewer_host <- "127.0.0.1"
viewer_port <- 3838

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
output_dir <- script_dir
viewer_cache_file <- file.path(output_dir, paste0(sample_name, "_deigidfonly_viewer_cache.rds"))

base_dir <- file.path(script_dir, sample_name)
config_dir_bin <- file.path(base_dir, "benchmark_distance_eigen_binary_configs")
config_dir_idf <- file.path(base_dir, "benchmark_distance_eigen_idfonly_configs")
group_summary_file <- file.path(base_dir, paste0(sample_name, "_allms2_pca_bin005_seed123_same_ms1_group_summary.csv"))

bin_membership_file <- file.path(config_dir_bin, "deigbin_rel005_nc30_nn5_cluster_membership.csv")
idf_membership_file <- file.path(config_dir_idf, "deigidfonly_rel005_nc30_nn5_cluster_membership.csv")

required_files <- c(group_summary_file, bin_membership_file, idf_membership_file)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) stop("Required files were not found: ", paste(missing_files, collapse = ", "))

group_summary <- read.csv(group_summary_file, stringsAsFactors = FALSE)
group_summary$group_scan_count <- as.integer(group_summary$group_scan_count)
group_summary$xcms_peak_idx <- as.integer(group_summary$xcms_peak_idx)
bin_df <- read.csv(bin_membership_file, stringsAsFactors = FALSE)
idf_df <- read.csv(idf_membership_file, stringsAsFactors = FALSE)

top_peaks <- group_summary[order(-group_summary$group_scan_count, group_summary$xcms_peak_idx), ]
top_peaks <- top_peaks[top_peaks$group_scan_count == 4, , drop = FALSE]
top_peaks <- top_peaks[1:min(10, nrow(top_peaks)), , drop = FALSE]
top_peak_ids <- top_peaks$xcms_peak_idx
peak_numbers <- setNames(seq_along(top_peak_ids), as.character(top_peak_ids))

palette_cols <- c(
  "#D1495B", "#00798C", "#EDAe49", "#30638E", "#8F2D56",
  "#66A182", "#A23B72", "#3E8914", "#4D9078", "#577590"
)
peak_colors <- setNames(palette_cols[seq_along(top_peak_ids)], as.character(top_peak_ids))

draw_presentation_plot <- function(df, main_title) {
  set.seed(123)
  highlight_rows <- df$xcms_peak_idx %in% top_peak_ids
  jitter_x <- df$umap_x
  jitter_y <- df$umap_y
  jitter_x[highlight_rows] <- jitter_x[highlight_rows] + stats::runif(sum(highlight_rows), -0.95, 0.95)
  jitter_y[highlight_rows] <- jitter_y[highlight_rows] + stats::runif(sum(highlight_rows), -0.95, 0.95)

  plot(
    df$umap_x,
    df$umap_y,
    pch = 16,
    cex = 0.45,
    col = "grey88",
    xlab = "UMAP 1",
    ylab = "UMAP 2",
    cex.lab = 1.4,
    cex.axis = 1.2,
    main = main_title,
    cex.main = 1.5
  )

  for (peak_id in top_peak_ids) {
    rows <- which(df$xcms_peak_idx == peak_id)
    if (length(rows) == 0) next
    text(
      jitter_x[rows],
      jitter_y[rows],
      labels = rep(peak_numbers[as.character(peak_id)], length(rows)),
      cex = 1.35,
      font = 2,
      col = peak_colors[as.character(peak_id)]
    )
  }

  legend(
    "topright",
    inset = c(-0.33, 0.02),
    legend = c(
      paste0(peak_numbers[as.character(top_peak_ids)], ": feature_", top_peak_ids),
      "other linked MS2"
    ),
    pch = c(rep(NA, length(top_peak_ids)), 16),
    col = c(unname(peak_colors[as.character(top_peak_ids)]), "grey88"),
    pt.cex = c(rep(NA, length(top_peak_ids)), 1.0),
    text.col = c(unname(peak_colors[as.character(top_peak_ids)]), "black"),
    bty = "n",
    cex = 1.05
  )
}

out_png <- file.path(output_dir, paste0(sample_name, "_deigidfonly_rel005_nc30_nn5_same_ms1_top10_numbers_presentation.png"))
png(out_png, width = 1800, height = 1500, res = 220)
par(mar = c(5, 5, 5, 8), xpd = TRUE)
draw_presentation_plot(idf_df, "IDF-only + distance eigenvector + UMAP")
dev.off()

compare_png <- file.path(output_dir, paste0(sample_name, "_deigbin_vs_deigidfonly_same_ms1_numbers_presentation.png"))
png(compare_png, width = 3200, height = 1500, res = 220)
par(mfrow = c(1, 2), mar = c(5, 5, 5, 8), xpd = TRUE)
draw_presentation_plot(bin_df, "0/1 + distance eigenvector + UMAP")
draw_presentation_plot(idf_df, "IDF-only + distance eigenvector + UMAP")
dev.off()

message("Wrote presentation PNG: ", out_png)
message("Wrote comparison PNG: ", compare_png)

call_api <- function(endpoint, data = NULL) {
  url <- paste0(base_url, endpoint)
  body <- if (is.null(data)) "null" else toJSON(data, auto_unbox = TRUE)
  tryCatch({
    res <- httr::POST(
      url,
      body = body,
      encode = "raw",
      httr::add_headers("Content-Type" = "application/json")
    )
    content_text <- httr::content(res, "text", encoding = "UTF-8")
    if (length(content_text) == 0 || content_text == "") {
      return(NULL)
    }
    fromJSON(content_text)
  }, error = function(e) NULL)
}

is_valid_masspp_id <- function(x) {
  !is.null(x) && length(x) == 1 && !is.na(x) && nzchar(as.character(x))
}

create_masspp_session <- function() {
  res <- call_api("io_create_sample")
  if (is.null(res)) {
    return(NULL)
  }
  if (is.list(res)) {
    return(res$id)
  }
  fromJSON(res)$id
}

send_scan_with_retry <- function(current_id, scan_data) {
  scan_data$id <- current_id
  add_res <- call_api("io_add_scan", scan_data)
  flush_res <- call_api("io_flush", list(id = current_id, index = 0))

  if (!is.null(add_res) && !is.null(flush_res)) {
    return(list(ok = TRUE, id = current_id, reconnected = FALSE, add_res = add_res, flush_res = flush_res))
  }

  new_id <- create_masspp_session()
  if (!is_valid_masspp_id(new_id)) {
    return(list(ok = FALSE, id = current_id, reconnected = FALSE, add_res = add_res, flush_res = flush_res))
  }

  scan_data$id <- new_id
  add_res <- call_api("io_add_scan", scan_data)
  flush_res <- call_api("io_flush", list(id = new_id, index = 0))

  if (!is.null(add_res) && !is.null(flush_res)) {
    return(list(ok = TRUE, id = new_id, reconnected = TRUE, add_res = add_res, flush_res = flush_res))
  }

  list(ok = FALSE, id = new_id, reconnected = FALSE, add_res = add_res, flush_res = flush_res)
}

format_num <- function(x, digits = 4) {
  ifelse(is.na(x), "NA", sprintf(paste0("%.", digits, "f"), x))
}

if (isTRUE(launch_masspp_viewer)) {
  message("Launching Mass++ viewer app...")
  viewer_df <- idf_df
  viewer_df$key_id <- seq_len(nrow(viewer_df))
  if (!file.exists(viewer_cache_file)) {
    stop(
      "Viewer cache was not found: ", viewer_cache_file,
      ". Run 'prepare_deig_idfonly_viewer_cache.R' first."
    )
  }
  viewer_cache <- readRDS(viewer_cache_file)
  subset_spectra <- viewer_cache$subset_spectra
  mz_axis <- viewer_cache$mz_axis
  message("Building Shiny UI...")

  ui <- fluidPage(
    titlePanel("IDF-only distance eigenvector UMAP to Mass++ Viewer"),
    fluidRow(
      column(
        width = 12,
        helpText("Click a point to send the filtered spectrum to Mass++. Colored labels correspond to the top same-MS1 groups used in the presentation figures."),
        plotlyOutput("scatterPlot", height = "780px")
      )
    )
  )

  server <- function(input, output, session) {
    vals <- reactiveValues(masspp_id = NULL)

    observe({
      new_id <- create_masspp_session()
      if (is_valid_masspp_id(new_id)) {
        vals$masspp_id <- new_id
        showNotification(paste("Mass++ Connected ID:", vals$masspp_id), duration = 3)
      } else {
        showNotification(
          "Mass++ connection failed. Please make sure Mass++ is running.",
          type = "error",
          duration = 5
        )
      }
    })

    output$scatterPlot <- renderPlotly({
      label_text <- ifelse(
        viewer_df$xcms_peak_idx %in% top_peak_ids,
        as.character(peak_numbers[as.character(viewer_df$xcms_peak_idx)]),
        ""
      )
      label_color <- ifelse(
        viewer_df$xcms_peak_idx %in% top_peak_ids,
        unname(peak_colors[as.character(viewer_df$xcms_peak_idx)]),
        "rgba(0,0,0,0)"
      )

      p <- plot_ly(
        data = viewer_df,
        x = ~umap_x,
        y = ~umap_y,
        type = "scatter",
        mode = "markers+text",
        key = ~key_id,
        customdata = ~key_id,
        text = label_text,
        textposition = "middle center",
        textfont = list(size = 16, color = label_color),
        hovertext = ~paste(
          "Feature:", feature_id,
          "<br>XCMS peak:", xcms_peak_idx,
          "<br>Precursor m/z:", format_num(precursor_mz, 4),
          "<br>Peak m/z:", format_num(xcms_peak_mz, 4),
          "<br>Peak rtmed:", format_num(xcms_peak_rtmed, 2),
          "<br>Acquisition:", ms2_acquisition_num,
          "<br>Subset row:", pca_subset_row,
          "<br>Cluster:", cluster_id
        ),
        hoverinfo = "text",
        marker = list(size = 7, opacity = 0.82, color = "grey84")
      ) %>%
        layout(
          title = "IDF-only + distance eigenvector + UMAP",
          xaxis = list(title = "UMAP 1"),
          yaxis = list(title = "UMAP 2")
        )
      event_register(p, "plotly_click")
    })

    observeEvent(event_data("plotly_click"), {
      event <- event_data("plotly_click")
      if (is.null(event)) {
        return()
      }

      target_id <- as.numeric(if (!is.null(event$key)) event$key else event$customdata)
      if (is.na(target_id) || target_id < 1 || target_id > nrow(viewer_df)) {
        return()
      }

      if (!is_valid_masspp_id(vals$masspp_id)) {
        new_id <- create_masspp_session()
        if (is_valid_masspp_id(new_id)) {
          vals$masspp_id <- new_id
          showNotification(paste("Mass++ Reconnected ID:", vals$masspp_id), duration = 3)
        } else {
          showNotification(
            "Mass++ is not connected. Please start Mass++ and try again.",
            type = "error",
            duration = 5
          )
          return()
        }
      }

      intensity_vec <- as.numeric(subset_spectra[target_id, ])
      valid_idx <- which(intensity_vec > 0)

      if (length(valid_idx) == 0) {
        showNotification("No peaks in this spectrum", type = "warning")
        return()
      }

      scan_data <- list(
        msLevel = 2,
        precursorMz = as.numeric(viewer_df$precursor_mz[target_id]),
        rt = as.numeric(viewer_df$ms2_retention_time[target_id]),
        points = data.frame(x = mz_axis[valid_idx], y = intensity_vec[valid_idx]),
        centroidMode = TRUE,
        minMz = mz_axis[min(valid_idx)] - 1,
        maxMz = mz_axis[max(valid_idx)] + 1
      )

      send_res <- send_scan_with_retry(vals$masspp_id, scan_data)
      vals$masspp_id <- send_res$id
      message("Mass++ send_res: ", paste(capture.output(str(send_res)), collapse = " "))
      message("Mass++ add_res: ", paste(capture.output(str(send_res$add_res)), collapse = " "))
      message("Mass++ flush_res: ", paste(capture.output(str(send_res$flush_res)), collapse = " "))

      if (!send_res$ok) {
        showNotification(
          "Mass++ transfer failed. Please check that Mass++ is running and the API is available.",
          type = "error",
          duration = 5
        )
      } else {
        if (isTRUE(send_res$reconnected)) {
          showNotification(paste("Mass++ Reconnected ID:", vals$masspp_id), duration = 3)
        }
        showNotification(
          paste("Sent", viewer_df$feature_id[target_id], "acq", viewer_df$ms2_acquisition_num[target_id]),
          duration = 1
        )
      }
    })
  }

  app <- shiny::shinyApp(ui, server)
  message("Starting Shiny app in browser at http://", viewer_host, ":", viewer_port, " ...")
  shiny::runApp(
    app,
    host = viewer_host,
    port = viewer_port,
    launch.browser = TRUE
  )
}

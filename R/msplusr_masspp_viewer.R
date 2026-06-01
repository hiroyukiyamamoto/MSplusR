library(shiny)
library(plotly)

create_masspp_umap_viewer <- function(
  umap_file,
  spectra_file,
  app_title = "UMAP to Mass++ Viewer",
  base_url = "http://localhost:8191/",
  default_ms_level = 2,
  centroid_mode = TRUE,
  wait_sec = 0
) {
  if (!file.exists(umap_file) || !file.exists(spectra_file)) {
    stop("Specified files were not found.")
  }

  load(file = umap_file)
  load(file = spectra_file)

  if (!exists("umap_result") || !exists("subset_spectra")) {
    stop("Required objects 'umap_result' and 'subset_spectra' were not found.")
  }

  samples <- data.frame(
    x = umap_result[, 1],
    y = umap_result[, 2],
    sample_id = seq_len(nrow(subset_spectra))
  )

  sample_session_id <- tryCatch(
    create_masspp_session(base_url = base_url),
    error = function(e) NULL
  )

  ui <- fluidPage(
    titlePanel(app_title),
    fluidRow(
      column(
        width = 8,
        plotlyOutput("scatterPlot", height = "700px")
      ),
      column(
        width = 4,
        h4("Mass++ session"),
        verbatimTextOutput("sessionInfo"),
        h4("Last sent spectrum"),
        verbatimTextOutput("lastSendInfo"),
        h4("Send history"),
        tableOutput("sendHistory")
      )
    )
  )

  server <- function(input, output, session) {
    session_id <- reactiveVal(sample_session_id)
    last_send <- reactiveVal("No spectrum has been sent yet.")
    send_history <- reactiveVal(
      data.frame(
        sample_id = integer(0),
        ms_level = integer(0),
        precursor_mz = numeric(0),
        rt = numeric(0),
        stringsAsFactors = FALSE
      )
    )

    output$scatterPlot <- renderPlotly({
      plot_ly(
        samples,
        x = ~x,
        y = ~y,
        type = "scatter",
        mode = "markers",
        text = ~paste("Sample ID:", sample_id),
        hoverinfo = "text",
        customdata = ~sample_id
      ) %>%
        layout(
          title = "UMAP Projection",
          xaxis = list(title = "UMAP 1"),
          yaxis = list(title = "UMAP 2")
        )
    })

    output$sessionInfo <- renderText({
      current_id <- session_id()
      if (is.null(current_id) || !nzchar(current_id)) {
        paste0("Not connected: ", base_url)
      } else {
        paste0("Connected\nBase URL: ", base_url, "\nSample ID: ", current_id)
      }
    })

    output$lastSendInfo <- renderText({
      last_send()
    })

    output$sendHistory <- renderTable({
      send_history()
    })

    observeEvent(event_data("plotly_click"), {
      event <- event_data("plotly_click")
      if (is.null(event)) {
        return()
      }

      target_id <- as.integer(event$customdata)
      if (!is.finite(target_id) || target_id < 1 || target_id > nrow(subset_spectra)) {
        showNotification("Invalid sample ID.", type = "error")
        return()
      }

      mz <- suppressWarnings(as.numeric(sub("\\-.*", "", colnames(subset_spectra))))
      intensity <- as.numeric(subset_spectra[target_id, ])

      precursor_mz <- if (!is.null(rownames(subset_spectra))) {
        suppressWarnings(as.numeric(rownames(subset_spectra)[target_id]))
      } else {
        NA_real_
      }
      if (!is.finite(precursor_mz)) {
        precursor_mz <- -1
      }

      rt <- as.numeric(target_id)
      current_id <- session_id()
      if (is.null(current_id) || !nzchar(current_id)) {
        current_id <- tryCatch(
          create_masspp_session(base_url = base_url),
          error = function(e) NULL
        )
        session_id(current_id)
      }

      if (is.null(current_id) || !nzchar(current_id)) {
        showNotification("Mass++ session could not be created.", type = "error")
        return()
      }

      send_res <- tryCatch(
        send_scan_to_masspp(
          mz = mz,
          intensity = intensity,
          sample_id = current_id,
          base_url = base_url,
          ms_level = default_ms_level,
          precursor_mz = precursor_mz,
          rt = rt,
          centroid_mode = centroid_mode,
          wait_sec = wait_sec
        ),
        error = function(e) e
      )

      if (inherits(send_res, "error")) {
        last_send(paste("Error:", conditionMessage(send_res)))
        showNotification(conditionMessage(send_res), type = "error")
        return()
      }

      last_send(
        paste0(
          "Sample ID: ", target_id,
          "\nMass++ sample: ", send_res$sample_id,
          "\nStatus: add ", send_res$add_res$status,
          ", flush ", send_res$flush_res$status
        )
      )

      send_history(
        head(
          rbind(
            data.frame(
              sample_id = target_id,
              ms_level = default_ms_level,
              precursor_mz = precursor_mz,
              rt = rt,
              stringsAsFactors = FALSE
            ),
            send_history()
          ),
          10
        )
      )

      showNotification(
        paste0("Sent sample ", target_id, " to Mass++."),
        type = "message"
      )
    })
  }

  shiny::runApp(shinyApp(ui, server))
}

library(shiny)
library(plotly)

# 必要なデータを読み込み
#load(file = "C:/R/umap_graph.rds")  # UMAP結果
#load(file = "C:/R/subset_spectra.rds")  # サブセット化されたスペクトルデータ

load(file = "C:/R/umap_pca.rds")  # UMAP結果
load(file = "C:/R/subset_spectra_pca.rds")  # サブセット化されたスペクトルデータ

# UIの定義
ui <- fluidPage(
  titlePanel("UMAP and MS/MS Spectrum Viewer with History"),
  fluidRow(
    column(
      width = 6,  # 左側の幅
      plotlyOutput("scatterPlot", height = "600px")  # 散布図 (UMAP)
    ),
    column(
      width = 6,  # 右側の幅
      fluidRow(
        plotOutput("spectrumPlot1", height = "200px"),  # 最新のスペクトル
        plotOutput("spectrumPlot2", height = "200px"),  # 2番目に新しいスペクトル
        plotOutput("spectrumPlot3", height = "200px")   # 3番目に新しいスペクトル
      )
    )
  )
)

# サーバーの定義
server <- function(input, output, session) {
  # サンプルIDとUMAP結果を結合するデータフレームを作成
  samples <- data.frame(
    x = umap_result[, 1],  # UMAP結果の第1次元
    y = umap_result[, 2],  # UMAP結果の第2次元
    sample_id = 1:nrow(subset_spectra)  # サンプルID
  )
  
  # 履歴を管理するリアクティブ値
  history <- reactiveValues(ids = integer(0))  # 選択されたサンプルIDの履歴
  
  # UMAP散布図を描画
  output$scatterPlot <- renderPlotly({
    plot_ly(
      samples, x = ~x, y = ~y, type = 'scatter', mode = 'markers',
      text = ~paste("Sample ID:", sample_id), hoverinfo = 'text',
      customdata = ~sample_id  # サンプルIDを埋め込む
    ) %>%
      layout(
        title = "UMAP Projection",
        xaxis = list(title = "UMAP 1"),
        yaxis = list(title = "UMAP 2")
      )
  })
  
  # クリックイベントをキャプチャして履歴を更新
  observeEvent(event_data("plotly_click"), {
    event <- event_data("plotly_click")
    if (!is.null(event)) {
      sample_id <- as.numeric(event$customdata)
      history$ids <- c(sample_id, history$ids)  # 履歴に新しいIDを追加
      history$ids <- unique(head(history$ids, 3))  # 履歴を最大3つに制限
    }
  })
  
  # スペクトルを描画（履歴に基づく3つのプロット）
  lapply(1:3, function(i) {
    output[[paste0("spectrumPlot", i)]] <- renderPlot({
      if (length(history$ids) >= i) {
        sample_id <- history$ids[i]
        spectrum <- data.frame(
          mz = as.numeric(sub("\\-.*", "", colnames(subset_spectra))),  # m/z範囲の開始値を抽出
          intensity = as.numeric(subset_spectra[sample_id, ])          # サンプルごとの強度値
        )
        
        # スペクトルをプロット
        plot(
          spectrum$mz, spectrum$intensity, type = "h", col = "blue",
          xlab = "m/z", ylab = "Intensity",
          main = paste("Spectrum for Sample", sample_id)
        )
      } else {
        plot(1, type = "n", xlab = "", ylab = "", main = "No spectrum available")
      }
    })
  })
}

# アプリの実行
shinyApp(ui, server)

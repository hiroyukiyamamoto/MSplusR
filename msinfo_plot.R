library(shiny)
library(plotly)

# サンプルデータ
set.seed(123)
samples <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  sample_id = 1:100
)

# MS/MSスペクトルデータを生成する関数
generate_spectrum <- function(sample_id) {
  set.seed(sample_id)
  data.frame(
    mz = seq(50, 500, length.out = 100),  # m/z範囲
    intensity = abs(rnorm(100, mean = 100, sd = 30))  # 強度
  )
}

# UIの定義
ui <- fluidPage(
  titlePanel("Click on points to see spectra"),
  sidebarLayout(
    sidebarPanel(
      helpText("散布図をクリックして、対応するスペクトルを表示します。")
    ),
    mainPanel(
      plotlyOutput("scatterPlot"),  # 散布図
      plotOutput("spectrumPlot")    # スペクトルプロット
    )
  )
)

# サーバーの定義
server <- function(input, output, session) {
  # 散布図を描画
  output$scatterPlot <- renderPlotly({
    plot_ly(
      samples, x = ~x, y = ~y, type = 'scatter', mode = 'markers',
      text = ~paste("Sample ID:", sample_id), hoverinfo = 'text',
      customdata = ~sample_id  # サンプルIDを埋め込む
    )
  })
  
  # スペクトルを描画
  output$spectrumPlot <- renderPlot({
    # クリックイベントからサンプル番号を取得
    event <- event_data("plotly_click")
    if (is.null(event)) {
      plot(1, type = "n", xlab = "", ylab = "", main = "Click on a point to see spectrum")
      return()
    }
    
    # 選択されたサンプルIDに基づいてスペクトルを取得
    sample_id <- as.numeric(event$customdata)
    spectrum <- generate_spectrum(sample_id)
    
    # スペクトルをプロット
    plot(
      spectrum$mz, spectrum$intensity, type = "h", col = "red",
      xlab = "m/z", ylab = "Intensity",
      main = paste("MS/MS Spectrum for Sample", sample_id)
    )
  })
}

# アプリの実行
shinyApp(ui, server)

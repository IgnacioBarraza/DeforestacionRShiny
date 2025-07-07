library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(DT)
library(openxlsx)

ui <- fluidPage(
  titlePanel("Análisis de Deforestación - Tamarugal y Pica"),
  sidebarLayout(
    sidebarPanel(
      fileInput("archivo", "Subir archivo Excel", accept = ".xlsx"),
      actionButton("analizar", "Analizar"),
      downloadButton("descargar", "Descargar Excel")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Frecuencia", DTOutput("tabla_frec")),
        tabPanel("Estadísticas", DTOutput("tabla_stats")),
        tabPanel("Gráfico de Barras", plotOutput("grafico_barras")),
        tabPanel("Tendencia Mensual", plotOutput("grafico_linea"))
      )
    )
  )
)

server <- function(input, output) {
  datos <- reactiveVal()
  frecuencia <- reactiveVal()
  estadisticas <- reactiveVal()
  mensual <- reactiveVal()
  
  observeEvent(input$analizar, {
    req(input$archivo)
    df <- read_excel(input$archivo$datapath)
    req(all(c("Tipo_Arbol", "Cantidad", "Fecha") %in% names(df)))
    
    df$Fecha <- as.Date(df$Fecha)
    datos(df)
    
    # Tabla de frecuencia
    frec <- df %>% count(Tipo_Arbol, name = "Frecuencia")
    frecuencia(frec)
    
    # Estadísticas
    stats <- df %>%
      group_by(Tipo_Arbol) %>%
      summarise(
        Media = mean(Cantidad),
        Mediana = median(Cantidad),
        Moda = as.numeric(names(sort(table(Cantidad), decreasing = TRUE))[1]),
        Desv.Std = sd(Cantidad),
        Varianza = var(Cantidad)
      )
    estadisticas(stats)
    
    # Análisis mensual
    df$Mes <- format(df$Fecha, "%m")
    mensual_data <- df %>%
      group_by(Mes, Tipo_Arbol) %>%
      summarise(Cantidad = sum(Cantidad), .groups = "drop")
    mensual(mensual_data)
  })
  
  output$tabla_frec <- renderDT({
    req(frecuencia())
    datatable(frecuencia())
  })
  
  output$tabla_stats <- renderDT({
    req(estadisticas())
    datatable(estadisticas())
  })
  
  output$grafico_barras <- renderPlot({
    req(frecuencia())
    ggplot(frecuencia(), aes(x = Tipo_Arbol, y = Frecuencia, fill = Tipo_Arbol)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Frecuencia por tipo de árbol", x = "Tipo de árbol", y = "Frecuencia") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$grafico_linea <- renderPlot({
    req(mensual())
    ggplot(mensual(), aes(x = as.integer(Mes), y = Cantidad, color = Tipo_Arbol)) +
      geom_line(size = 1) +
      geom_point() +
      theme_minimal() +
      labs(title = "Cantidad mensual de deforestación", x = "Mes", y = "Cantidad") +
      scale_x_continuous(breaks = 1:12)
  })
  
  output$descargar <- downloadHandler(
    filename = function() {
      paste("reporte_deforestacion_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      wb <- createWorkbook()
      addWorksheet(wb, "Frecuencia")
      writeData(wb, "Frecuencia", frecuencia())
      addWorksheet(wb, "Estadísticas")
      writeData(wb, "Estadísticas", estadisticas())
      addWorksheet(wb, "Mensual")
      writeData(wb, "Mensual", mensual())
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )
}

shinyApp(ui, server)

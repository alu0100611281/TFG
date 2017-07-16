

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  shinythemes::themeSelector(),
  #ui <- basicPage(
  tags$head(

    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
    "))
  ),
  headerPanel(
    h1("Eficiencia energética en sistemas de cómputo de altas prestaciones",
       style = "font-family: 'Lobster', cursive;
        font-weight: 500; line-height: 1.1;
        color: #4d3a7d;")),
 
  #CARGA DE DATOS
  fileInput(
    "Datos",
    "Abra su Documento",
    accept = c("text/csv",
               "text/comma-separated-values,text/plain",
               ".csv")
    
  ),
  
  sidebarLayout(
    sidebarPanel(
      #SELECCION DE TIPO DE GRAFICO
      selectInput("Graficos", "Seleciones una Tabla:",
                  list(
                    `Graficos` = c(
                      "Grafico de Dispersion",
                      "Histograma",
                      "Diagrama de caja",
                      "graficos cuantil",
                      "Grafico de Barras"
                    )
                  )),
      titlePanel("Control de Grafico"),
      tabsetPanel(
        id = "tabset",
        
        tabPanel(
          "Normal",
          
          #SELECCION DE RANGOS MANUALES
          
          numericInput("captionmin", "Xmin", 0),
          numericInput("captionmax", "Xmax", 0)
          
        ),
        tabPanel("Slider",
                 #SELECCION DE RANGO CON SLIDER
                 sliderInput(
                   "ejex", "Eje x", 0, 0, value = c(0, 0), step = 1
                 )),
        tabPanel(
          "Editar",
          
          textAreaInput(
            "Texty",
            "Nombre eje y",
            width = "250px",
            height = "30px"
          ),
          textAreaInput(
            "Textx",
            "Nombre eje x",
            width = "250px",
            height = "30px"
          )
        )
      ),
      actionButton("go", "Dibujar"),
      
      titlePanel("Ecuacion"),
      textAreaInput(
        "formulas",
        "Introduzca su Ecuacion",
        width = "250px",
        height = "30px"
      ),
      actionButton("ca", "Calcular")
    ),
    
    
    mainPanel(plotOutput("plots"))
  )
  
))

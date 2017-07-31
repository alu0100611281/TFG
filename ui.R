################################################################################################
######                                                                                     #####
######                              TRABAJO FIN DE GRADO                                   #####
######            Eficiencia Energetica en sistemas de cómputo de altas prestaciones       #####
######                           Jose Luis González Hernández                              #####
######                                                                                     #####
################################################################################################

library(manipulate)
library(shiny)
library(shinythemes)


shinyUI(
  fluidPage(
    theme = shinytheme("flatly"),
    shinythemes::themeSelector(),
    #ui <- basicPage(
    tags$head(tags$style(
      HTML(
        "
        @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
        "
      )
      )),
    headerPanel(
      h1(
        "Visualización de datos de eficiencia energética en sistemas de cómputo de altas prestaciones",
        style = "font-family: 'Lobster', cursive;
        font-weight: 500; line-height: 1.1;
        color: #4d3a7d;"
      )
    ),
    
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
        selectInput("Graficos", "Selecione una Grafica:",
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
            
            textAreaInput("Texty",
                          "Nombre eje y",
                          width = "250px",
                          height = "30px"),
            textAreaInput("Textx",
                          "Nombre eje x",
                          width = "250px",
                          height = "30px")
          )
        ),
        
        
        selectInput(
          "Ecuacion",
          "Seleciones de ecuacion:",
          list(
            `Ecuacion` = c("Ecuaciones"),
            `Regresion Lineal` = c("y=Ax+B", "y=A+Bx"),
            `Regresion Lineal Multiple` = c("y=Ax+Bx^2+C", "y=Ax+Bx^2+Cx^3+D", "y=Ax+Bx^2+Cx^3+Dx^4+E"),
            `Logaritmica` = c("y=A*ln(x)+B", "y=A+B*ln(x)"),
            `Exponencial` = c("y=A^x+B", "y=Ax+ln(B)"),
            `Compuesto` = c("y=A^x*B", "ln(y)=(ln(A)*x)+ln(B)")
            
          )
        ),
        actionButton("go", "Dibujar")
        
      ),
      
      mainPanel(plotOutput("plots"))
      
    ),
    sidebarLayout(
      sidebarPanel(
        width = 10,
        titlePanel("Información"),
        verbatimTextOutput("modelSummary")
        
      ),
      mainPanel()
      
    )
    
    
      )
  )

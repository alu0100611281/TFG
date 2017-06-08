
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
#library(shiny)

#shinyUI(fluidPage(
ui <- basicPage(
  # Application title
  titlePanel("Eficiencia energética en sistemas de cómputo de altas prestaciones"),

  fileInput("Datos", "Abra su Documento",
         accept = c(
             "text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")
                 
  ),
  selectInput("Formulas", "Seleciones una formula:",
              list(`Formulas` = c("Tabla principal","Media", "Mediana", "Desviacion estandar","Varianza","Correlacion","Dispercion Lineal")
                   )
  ),
  
  selectInput("Graficos", "Seleciones una Tabla:",
              list(`Graficos` = c("Grafico de Dispersion","Histograma","Diagrama de caja","graficos cuantil","Grafico de Barras")
              )
  ),
  
  
    
  

    # Show a plot of the generated distribution
    mainPanel(
      
      #tableOutput("contents"), 
      plotOutput("plots",brush = "plots"),
      verbatimTextOutput("info")
      
      
      
      
      
    )
  
  
)

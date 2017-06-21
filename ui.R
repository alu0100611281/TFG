
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
library(shiny)

shinyUI(fluidPage(
#ui <- basicPage(
  # tITULO
  titlePanel("Eficiencia energética en sistemas de cómputo de altas prestaciones"),
  
  #CARGA DE DATOS
  fileInput("Datos", "Abra su Documento",
         accept = c(
             "text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")
                 
  ),
  # selectInput("Formulas", "Seleciones una formula:",
  #             list(`Formulas` = c("Tabla principal","Media", "Mediana", "Desviacion estandar","Varianza","Correlacion","Dispercion Lineal")
  #                  )
  # ),
  
  #SELECCION DE TIPO DE GRAFICO
  selectInput("Graficos", "Seleciones una Tabla:",
              list(`Graficos` = c("Grafico de Dispersion","Histograma","Diagrama de caja","graficos cuantil","Grafico de Barras")
              )
  ),
  
  #SELECCION DE RANGOS MANUALES
  textAreaInput("captionmin", "Xmin",value=MIN, width = "50px",height ="50px"),
  textAreaInput("captionmax", "Xmax",value=MAX,  width = "50px",height ="50px"),
  
  
  #SELECCION DE RANGO CON SLIDER
  sliderInput("ejex","Eje x",0,0,value=c(0,0),step=1),# dragRange = FALSE),
  
  #INTRODUCCION DE FORMULAS
  textAreaInput("formulas", "Introduzca su Formula", width = "300px",height ="30px"),
   
    mainPanel(
      plotOutput("plots")
    )
  
  
))

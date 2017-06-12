
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
library(shiny)

shinyUI(fluidPage(
#ui <- basicPage(
  # Application title
  titlePanel("Eficiencia energética en sistemas de cómputo de altas prestaciones"),

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
  
  selectInput("Graficos", "Seleciones una Tabla:",
              list(`Graficos` = c("Grafico de Dispersion","Histograma","Diagrama de caja","graficos cuantil","Grafico de Barras")
              )
  ),
  
  textAreaInput("captionmin", "Xmin",value=MIN, width = "50px",height ="50px"),
  textAreaInput("captionmax", "Xmax",value=MAX,  width = "50px",height ="50px"),
  
 
  
  
 sliderInput("ejex","Eje x",0,0,value=c(0,0),step=1),# dragRange = FALSE),
  

    # Show a plot of the generated distribution
    mainPanel(
      # tabsetPanel(      Sirve para ver el contenido del fichero una vez abierto
      #   tabPanel("CSV",
      #            h4("Vista del fichero CSV"),
      #            tableOutput('contents')
      #            )
      # ),
      #tableOutput("contents"), 
      #plotOutput("plots"),#brush = "plots"),
     # verbatimTextOutput("info")
      plotOutput("plots")
      # tabPanel("Plot",plotOutput("plots"))
     #verbatimTextOutput("value1"),
      #verbatimTextOutput("value2")
    
      
      
      
      
    )
  
  
))

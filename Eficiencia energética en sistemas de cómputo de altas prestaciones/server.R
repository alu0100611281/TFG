
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
library(shiny)

shinyServer(function(input, output,session){
#server <- function(input, output) {
  
  #***********cargando datos******************************************************************
  
  output$contents <- renderTable({#funcion para cargar archivo
    inFile <- input$Datos
    
    if (is.null(inFile))
      return(NULL)
    
    read.table(inFile$datapath, sep = " ",quote="\"")
  })
  
  
  output$plots <- renderPlot({
   inFile <- input$Datos
    
   if (is.null(inFile))
     return(NULL)
    
    
   datos <- read.table(inFile$datapath,sep = " ",quote="\"")
   t<-1
   
   imprimir(datos)
   #***********fin cargando datos******************************************************************
   
   #***********RANGOS MANUALES******************************************************************
   value1 <- renderText({ input$captionmin })
   value2 <- renderText({ input$captionmax })

   xmin<<-input$captionmin
   xmax<<-input$captionmax
   
   if(xmax!=0){ #Miramos si ha introducido un rango 
     matrix(datos)

          t=2
          i<-1
          j<-1
          c1<<-vector()
          c2<<-vector()
          z<-1

          for(i in seq_len(nrow(datos))) {

            for(j in seq_len(ncol(datos))){
              if(j<=1){
                if((matrix(datos[i,j])>=xmin) && (matrix(datos[i,j])<=xmax)){ #&& ((matrix(datos[i,j+1])>=ymin) && (matrix(datos[i,j+1])<=ymax))){

                  c1[z]=matrix(datos[i,j])
                  c2[z]=matrix(datos[i,j+1])

                  z=z+1

                }

              }

            }
          }

          datos2<<-data.frame(c1,c2)
     
   imprimir(datos2)
   
   }
   #***********FIN RANGOS MANUALES******************************************************************
   
   #**********************Seleccionar rango con slider**************************************************************
   
   
   MAX<<-0
   MIN<<-0
   i<-1
   MIN=datos[i,]
   for(i in seq_len(nrow(datos))){

     if((datos[i,])>=MAX){
       MAX=datos[i,]
     }
     if((datos[i,])<MIN){
       MIN=datos[i,]
     }
   }
  
   
     val <- input$ejex
     
     updateSliderInput(session, "ejex", value = val,
                       min = MIN$V1, max = MAX$V1, step = 1)
  
   if(val[1]!=MAX$V1 && val[2]!=MIN$V1){
   matrix(datos)
   View(t)
   t=2
   i<-1
   j<-1
   c1<<-vector()
   c2<<-vector()
   z<-1

   for(i in seq_len(nrow(datos))) {

     for(j in seq_len(ncol(datos))){
       if(j<=1){
         if((matrix(datos[i,j])>=val[1]) && (matrix(datos[i,j])<=val[2])){ #&& ((matrix(datos[i,j+1])>=ymin) && (matrix(datos[i,j+1])<=ymax))){

           c1[z]=matrix(datos[i,j])
           c2[z]=matrix(datos[i,j+1])

           z=z+1

         }

       }

     }
   }

   datos2<<-data.frame(c1,c2)

   imprimir(datos2)
   
   }
 #****************************** fin slider****************************************************************************   
   
 #****************************** SELECCIONAR RANGO CON RATON***********************************************************  
   
  #  #grafica seleccion
  #
  # # output$plot1 <- renderPlot({
  # # plot(mtcars$wt, mtcars$mpg)
  #  #})
  #  output$info <- renderText({
  #
  #    xy_range_str <- function(e) {
  #      if(is.null(e)) return("NULL\n")
  #      xmin<-round(e$xmin, 1)
  #      xmax<-round(e$xmax, 1)
  #      #ymax<-round(e$ymax, 1)
  #      #ymin<-round(e$ymin, 1)
  #
  #      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1),
  #             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
  #      matrix(datos)
  #
  #
  #      i<-1
  #      j<-1
  #      c1<<-vector()
  #      c2<<-vector()
  #      z<-1
  #
  #      for(i in seq_len(nrow(datos))) {
  #
  #        for(j in seq_len(ncol(datos))){
  #          if(j<=1){
  #            if((matrix(datos[i,j])>=xmin) && (matrix(datos[i,j])<=xmax)){ #&& ((matrix(datos[i,j+1])>=ymin) && (matrix(datos[i,j+1])<=ymax))){
  #
  #              c1[z]=matrix(datos[i,j])
  #              c2[z]=matrix(datos[i,j+1])
  #
  #              z=z+1
  #
  #            }
  #
  #          }
  #
  #        }
  #      }
  #
  #      datos2<<-data.frame(c1,c2)
  #
  #      plot(datos2,add=TRUE,"h", xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
  #    }
  #
  #    paste0(
  #      "brush: ", xy_range_str(input$plots),resetOnNew=TRUE
  #    )
  #    imprimir<-datos2
  #  })
  #
  # # plot(datos2,"h", xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
  #
  #  #plot(datos,"h", xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
     #value1 <- renderText({ input$MIN})
 #****************************** FIN SELECCIONAR RANGO CON RATON***********************************************************   
     
    
   #**********************************Seleccion  de tipo de Graficos*******************************************************

   Grafi <- input$Graficos
   if(Grafi == "Histograma"){
     if(t==2){
     hist(datos2$c2,xlab="Cpu", ylab="Tiempo",main = "Histograma")
       }
     # if(t==3){
     #   hist(datos3$c4,xlab="Cpu", ylab="Tiempo",main = "Histograma")
     #   }
     if(t==1){
       hist(datos$V2,xlab="Cpu", ylab="Tiempo",main = "Histograma")
     }
   }
   if(Grafi == "Grafico de Dispersion"){
     if(t==2){
     plot(datos2, xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
     }
     # if(t==3){
     #   plot(datos3, xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
     # }
     if(t==1)
     {
       plot(datos, xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
     }
   }
   if(Grafi =="Diagrama de caja"){
     if(t==2){
     boxplot(datos2,main = "Boxplot", xlab="Cpu", ylab="Tiempo")
     col = terrain.colors(3)
     }
     # if(t==3){
     #   boxplot(datos3,main = "Boxplot", xlab="Cpu", ylab="Tiempo")
     #   col = terrain.colors(3)
     # }
     if(t==1)
     {
       boxplot(datos,main = "Boxplot", xlab="Cpu", ylab="Tiempo")
       col = terrain.colors(3)
     }
   }
   
   if(Grafi =="graficos cuantil"){
     if(t==2){
     qqplot(datos2$c1,datos2$c2, col = "blue",xlab="Cpu", ylab="Tiempo", main = "Cuantiles")
     }
     # if(t==3){
     #   qqplot(datos3$c3,datos3$c4, col = "blue",xlab="Cpu", ylab="Tiempo", main = "Cuantiles")
     # }
     if(t==1){
       qqplot(datos$V1,datos$V2, col = "blue",xlab="Cpu", ylab="Tiempo", main = "Cuantiles")
     }
   }
   if(Grafi =="Grafico de Barras"){
     if(t==2){
     barplot(datos2$c1,xlab="Cpu", ylab="Tiempo", main = "Gráfico de barras")
     }
     # if(t==3){
     #   barplot(datos3$c3,xlab="Cpu", ylab="Tiempo", main = "Gráfico de barras")
     # }
     if(t==1){
       barplot(datos$V1,xlab="Cpu", ylab="Tiempo", main = "Gráfico de barras")
     }
   }

   #**********************************Fin Seleccion de Graficos***************************************************************


   #Formulas
    # formu <- input$Formulas
    # if(formu =="Correlacion"){
    #   plot(V1 ~ V2, data=datos,xlab="Cpu", ylab="Tiempo", main="Correlacion")
    #   #points(cor(datos$V1,datos$V2))
    #   }
    # if(formu =="Media"){
    #   plot(datos$V1,datos$V2, xlab="Cpu", ylab="Tiempo", main="Media")
    #   abline(h=(mean(datos$V1)),col=(mean(datos$V2)))
    #   }
    # if(formu =="Mediana"){
    #   plot(datos$V1,datos$V2, xlab="Cpu", ylab="Tiempo", main="Mediana")
    #   abline(h=(median(datos$V1)),col=(median(datos$V2)))
    #   }
    # if(formu =="Desviacion estandar"){
    #   plot(datos$V1,datos$V2, xlab="Cpu", ylab="Tiempo", main="Desviacion estandar")
    #   abline(h=(sd(datos$V1)),col=(sd(datos$V2)))
    #   }
    # if(formu =="Varianza"){
    #   plot(datos$V1,datos$V2,xlab="Cpu", ylab="Tiempo", main="Varianza")
    #   abline(h=(var(datos$V1)),col=(var(datos$V2)))
    #   }
    # if(formu =="Dispercion Lineal"){
    #   plot(V1 ~ V2, data=datos,xlab="Cpu", ylab="Tiempo", main="Dispercion Lineal")
    #   #points(cor(datos$V1,datos$V2))
    #   lines(lowess(datos$V1~datos$V2),col="red")
    #   #scatter.smooth(datos$V1~datos$V2)
    #   #scatter.smooth(datos$V1~datos$V2, pch=16,cex=.6,xlab="Cpu", ylab="Tiempo", main="Dispercion Lineal")
    #   }

            #histograma
            #boxplot(datos)
            #boxplot(data.frame(datos))
            #x=rnorm(1000)
            #hist(datos$V2,xlab="Cpu", ylab="Tiempo", main="Correlacion")




  })
  #********************************Imprimir***************************************************
  imprimir<-function(x){
 
    plot(x,xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
  
  }
  #********************************fin Imprimir***********************************************
})

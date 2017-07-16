
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(manipulate)
library(shiny)

shinyServer(function(input, output, session) {
  #1
  #server <- function(input, output) {
  
  #***********cargando datos******************************************************************
  
  output$contents <- renderTable({
    #funcion para cargar archivo 2
    inFile <- input$Datos
    
    if (is.null(inFile))
      return(NULL)
    
    read.table(inFile$datapath, sep = " ", quote = "\"")
  })#2
  
  
  output$plots <- renderPlot({
    #3
    inFile <- input$Datos
    
    if (is.null(inFile))
      return(NULL)
    
    
    datos <- read.table(inFile$datapath, sep = " ", quote = "\"")
    t <- 1
    z <- 1
    
    #***********fin cargando datos******************************************************************
    
    #***********************************Control de grafica*************************************************
    maximo <<- 0
    minimo <<- 0
    
    minimo <- min(datos$V1)
    maximo <- max(datos$V1)
    val2  <- input$ejex
    val2[1] <- minimo
    val2[2] <- maximo
    observe(updateNumericInput(session, "captionmin", value = minimo))
    observe(updateNumericInput(session, "captionmax", value = maximo))
    
    observe(updateSliderInput(
      session,
      "ejex",
      value = val2,
      min = minimo,
      max = maximo,
      step = 1
    ))
    
    v <- reactiveValues(doPlot = FALSE)
    
    observeEvent(input$go, {
      # 0 will be coerced to FALSE
      # 1+ will be coerced to TRUE
      v$doPlot <- input$go
      
    })
    
    observeEvent(input$tabset, {
      v$doPlot <- FALSE
      
    })
    
    output$plots <- renderPlot({
      
      
      if (v$doPlot == FALSE)
        return()
      
      
      isolate({
        if (input$tabset == "Slider") {
          MIN <- min(datos$V1)
          MAX <- max(datos$V1)
          val  <- input$ejex
          
          observe(updateSliderInput(
            session,
            "ejex",
            value = val,
            min = MIN,
            max = MAX,
            step = 1
          ))
          observe(updateNumericInput(session, "captionmin", value = val[1]))
          observe(updateNumericInput(session, "captionmax", value = val[2]))
          if (val[1] != MAX && val[2] != MIN) {
            matrix(datos)
            
            t = 2
            i <- 1
            j <- 1
            c1 <<- vector()
            c2 <<- vector()
            z <- 1
            
            for (i in seq_len(nrow(datos))) {
              for (j in seq_len(ncol(datos))) {
                if (j <= 1) {
                  if ((matrix(datos[i, j]) >= val[1]) &&
                      (matrix(datos[i, j]) <= val[2])) {
                    #&& ((matrix(datos[i,j+1])>=ymin) && (matrix(datos[i,j+1])<=ymax))){
                    
                    c1[z] = matrix(datos[i, j])
                    c2[z] = matrix(datos[i, j + 1])
                    
                    z = z + 1
                    
                  }
                  
                }
                
              }
            }
            
            datos2 <<- data.frame(c1, c2)
            
            
            
          }
        } else {
          xmin <<- input$captionmin
          xmax <<- input$captionmax
          val2[1] <- xmin
          val2[2] <- xmax
          observe(
            updateSliderInput(
              session,
              "ejex",
              value = val2,
              min = minimo,
              max = maximo,
              step = 1
            )
          )
          matrix(datos)
          
          t = 2
          i <- 1
          j <- 1
          c1 <<- vector()
          c2 <<- vector()
          z = 1
          
          for (i in seq_len(nrow(datos))) {
            for (j in seq_len(ncol(datos))) {
              if (j <= 1) {
                if ((matrix(datos[i, j]) >= xmin) && (matrix(datos[i, j]) <= xmax)) {
                  c1[z] = matrix(datos[i, j])
                  c2[z] = matrix(datos[i, j + 1])
                  
                  z = z + 1
                  
                }
                
              }
              
            }
          }
          
          datos2 <<- data.frame(c1, c2)
          
          
          if (input$tabset == "Editar"){
            # observe(updateNumericInput(session, "captionmin", value = val[1]))
            texty<-input$Texty
            textx<-input$Textx
     
              # observe(updateTextAreaInput(session,"plots",ylab=texty))
              # observe(updateTextAreaInput(session,"plots",xlab=textx))
           
          }
          
        }
        #**********************************Seleccion  de tipo de Graficos*******************************************************
        
        Grafi <- input$Graficos
        if (Grafi == "Histograma") {
          if (t == 2) {
            hist(
              datos2$c2,
               xlab = input$Textx,
               ylab = input$Texty,
              main = "Histograma"
            )
          }
          # if(t==3){
          #   hist(datos3$c4,xlab="Cpu", ylab="Tiempo",main = "Histograma")
          #   }
          if (t == 1) {
            hist(datos$V2,
                 xlab = input$Textx,
                 ylab = input$Texty,
                 main = "Histograma")
          }
        }
        if (Grafi == "Grafico de Dispersion") {
          if (t == 2) {
            plot(datos2,
                xlab<-input$Textx,
                ylab<-input$Texty,
                 
                 main = "Eficiencia energética")
          }
          # if(t==3){
          #   plot(datos3, xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
          # }
          if (t == 1)
          {
            plot(datos,
                 xlab<-input$Textx,
                 ylab<-input$Texty,
                 main = "Eficiencia energética")
          }
        }
        if (Grafi == "Diagrama de caja") {
          if (t == 2) {
            boxplot(datos2,
                    main = "Boxplot",
                    xlab = input$Textx,
                    ylab = input$Texty)
            col = terrain.colors(3)
          }
          # if(t==3){
          #   boxplot(datos3,main = "Boxplot", xlab="Cpu", ylab="Tiempo")
          #   col = terrain.colors(3)
          # }
          if (t == 1)
          {
            boxplot(datos,
                    main = "Boxplot",
                    xlab = input$Textx,
                    ylab = input$Texty)
            col = terrain.colors(3)
          }
        }
        
        if (Grafi == "graficos cuantil") {
          if (t == 2) {
            qqplot(
              datos2$c1,
              datos2$c2,
              col = "blue",
              xlab = input$Textx,
              ylab = input$Texty,
              main = "Cuantiles"
            )
          }
          # if(t==3){
          #   qqplot(datos3$c3,datos3$c4, col = "blue",xlab="Cpu", ylab="Tiempo", main = "Cuantiles")
          # }
          if (t == 1) {
            qqplot(
              datos$V1,
              datos$V2,
              col = "blue",
              xlab = input$Textx,
              ylab = input$Texty,
              main = "Cuantiles"
            )
          }
        }
        if (Grafi == "Grafico de Barras") {
          if (t == 2) {
            barplot(
              datos2$c1,
              xlab = input$Textx,
              ylab = input$Texty,
              main = "Gráfico de barras"
            )
          }
          # if(t==3){
          #   barplot(datos3$c3,xlab="Cpu", ylab="Tiempo", main = "Gráfico de barras")
          # }
          if (t == 1) {
            barplot(datos$V1,
                    xlab = input$Textx,
                    ylab = input$Texty,
                    main = "Gráfico de barras")
          }
        }
        
        #**********************************Fin Seleccion de Graficos***************************************************************
        #imprimir(datos2)
      })
    })#4
    #**********************************fin control de grafica********************************************
    
    
    
    
    #**********************************Seleccion  de formula******************************************************************
    
    # l <- reactiveValues(duPlot = FALSE)
    # 
    # observeEvent(input$ca, {
    #   # 0 will be coerced to FALSE
    #   # 1+ will be coerced to TRUE
    #   l$duPlot <- input$ca
    # 
    # })
    # 
    # # observeEvent(input$tabset, {
    # #   l$duPlot <- FALSE
    # #   
    # # })
    # 
    #  output$plots <- renderPlot({
    #   
    #   
    #   if (l$duPlot == FALSE)
    #     return()
    #   
    #   
    #   isolate({
        expresion <- input$formulas
        d <- nchar(expresion)
    
    
        expresion_split = strsplit(expresion, split = "") #dividims la formula en individual para tratarla mejor
        expresion_columnas = data.frame(unlist(expresion_split))
    
    f <- vector()
    f <- expresion_columnas
    i <- 1
    
    if (nchar(expresion) >= 1) {
      for (i in nchar(expresion)) {
        if (f[i, ] == "y")
          y = y + 1
        
        
        if (f[i, ] == "x")
          x = x + 1
      }
      
      if (t == 1) {
        # if(f[1,]=="y" && (f[3,]>=65 && f[3,]<=90)   && f[4,]== "x" && (f[6,]>=65 && f[6,]<=90)){
        # if(f[1,]=="y" && f[4,]== "x"){
        if (y == 1 && x == 1) {
          y <- datos$V2
          x <- datos$V1
          regresion <- lm(y ~ x, datos)
          abline(regresion)
        }
      }
      
      else{
        y <- datos2$c2
        x <- datos2$c1
        regresion <- lm(y ~ x, datos2)
        abline(regresion)
      }
    }
    # residuos <- rstandard(regresion)
    # valores.ajustados <- fitted(regresion)
    # View(residuos)
    # View(valores.ajustados)
    #  summary(regresion)$call
    # coeficiente<-coef(regresion)
    # View(coeficiente)
    # regresion$coefficients
    # str(summary(regresion))
    
    #qqnorm(residuos)
    #qqline(residuos)
      
    #   })
    # })
    #***************************fin formulas***************************************************
    
    #**************************boton reset*****************************************************
    
    
    
    #*************************fin boton reset**************************************************
  })#3
  #********************************Imprimir***************************************************
  # imprimir <- function(x) {
  #   plot(x,
  #        xlab ,
  #        ylab ,
  #        main = "Eficiencia energética")
  #   
  # }
  #********************************fin Imprimir***********************************************
  
  
})#1

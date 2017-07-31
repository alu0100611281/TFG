################################################################################################
######                                                                                     #####
######                              TRABAJO FIN DE GRADO                                   #####
######            Eficiencia Energetica en sistemas de cómputo de altas prestaciones       #####
######                           Jose Luis González Hernández                              #####
######                                                                                     #####
################################################################################################




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
                if ((matrix(datos[i, j]) >= xmin) &&
                    (matrix(datos[i, j]) <= xmax)) {
                  c1[z] = matrix(datos[i, j])
                  c2[z] = matrix(datos[i, j + 1])
                  
                  z = z + 1
                  
                }
                
              }
              
            }
          }
          
          datos2 <<- data.frame(c1, c2)
          
          
          if (input$tabset == "Editar") {
            # observe(updateNumericInput(session, "captionmin", value = val[1]))
            texty <- input$Texty
            textx <- input$Textx
            
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
            hist(
              datos$V2,
              xlab = input$Textx,
              ylab = input$Texty,
              main = "Histograma"
            )
          }
        }
        if (Grafi == "Grafico de Dispersion") {
          if (t == 2) {
            plot(datos2,
                 xlab <- input$Textx,
                 ylab <- input$Texty,
                 
                 main = "Eficiencia energética")
          }
          # if(t==3){
          #   plot(datos3, xlab="Cpu", ylab="Tiempo", main="Eficiencia energética")
          # }
          if (t == 1)
          {
            plot(datos,
                 xlab <- input$Textx,
                 ylab <- input$Texty,
                 main = "Eficiencia energética")
          }
        }
        if (Grafi == "Diagrama de caja") {
          if (t == 2) {
            boxplot(
              datos2,
              main = "Boxplot",
              xlab = input$Textx,
              ylab = input$Texty
            )
            col = terrain.colors(3)
          }
          # if(t==3){
          #   boxplot(datos3,main = "Boxplot", xlab="Cpu", ylab="Tiempo")
          #   col = terrain.colors(3)
          # }
          if (t == 1)
          {
            boxplot(
              datos,
              main = "Boxplot",
              xlab = input$Textx,
              ylab = input$Texty
            )
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
            barplot(
              datos$V1,
              xlab = input$Textx,
              ylab = input$Texty,
              main = "Gráfico de barras"
            )
          }
        }
        
        #**********************************Fin Seleccion de Graficos***************************************************************
        #imprimir(datos2)
        #}) #isolate
        #})#4
        #**********************************fin control de grafica********************************************
        
        
        
        
        #**********************************Seleccion  de formula******************************************************************
        
        expresion <- input$Ecuacion
        
        if (expresion == "y=Ax+B" || expresion == "y=A+Bx") {
          if (t == 1) {
            y <- datos$V2
            x <- datos$V1
            regresion <- lm(y ~ x, datos)
            summary(regresion)
            abline(regresion)
            
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            regresion <- lm(y ~ x, datos2)
            summary(regresion)
            abline(regresion)
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
          
        }
        
        if (expresion == "y=Ax+Bx^2+C") {
          if (t == 1) {
            y <- datos$V2
            x <- datos$V1
            
            regresion <- lm(y ~ x + I(x ^ 2), data = datos)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2,
              add = T,
              col = "red"
            )
            
            
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            
            regresion <- lm(y ~ x + I(x ^ 2), data = datos2)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2,
              add = T,
              col = "red"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        if (expresion == "y=Ax+Bx^2+Cx^3+D") {
          if (t == 1) {
            y <- datos$V2
            x <- datos$V1
            
            regresion <-
              lm(y ~ x + I(x ^ 2) + I(x ^ 3), data = datos)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2 + regresion$coefficient[4] * x ^ 3,
              add = T,
              col = "red"
            )
            
            
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            regresion <-
              lm(y ~ x + I(x ^ 2) + I(x ^ 3), data = datos2)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2 + regresion$coefficient[4] * x ^ 3,
              add = T,
              col = "red"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        if (expresion == "y=Ax+Bx^2+Cx^3+Dx^4+E") {
          if (t == 1) {
            y <- datos$V2
            x <- datos$V1
            regresion <-
              lm(y ~ x + I(x ^ 2) + I(x ^ 3) + I(x ^ 4), datos)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2 + regresion$coefficient[4] * x ^ 3 + regresion$coefficient[5] * x ^
                4,
              add = T,
              col = "red"
            )
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            regresion <-
              lm(y ~ x + I(x ^ 2) + I(x ^ 3) + I(x ^ 4), datos2)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * x + regresion$coefficient[3] *
                x ^ 2 + regresion$coefficient[4] * x ^ 3 + regresion$coefficient[5] * x ^
                4,
              add = T,
              col = "red"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        if (expresion == "y=A*ln(x)+B" || expresion == "y=A+B*ln(x)") {
          if (t == 2) {
            y <- datos$V2
            x <- datos$V1
            tras <- log(datos$V1)
            regresion <- lm(y ~ tras, datos)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * log(x),
              add = T,
              col = "violet"
            )
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            tras <- log(datos$c1)
            regresion <- lm(y ~ tras, datos2)
            summary(regresion)
            curve(
              regresion$coefficient[1] + regresion$coefficient[2] * log(x),
              add = T,
              col = "violet"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        if (expresion == "y=A^x+B" || expresion == "y=Ax+ln(B)") {
          if (t == 2) {
            y <- datos$V2
            x <- datos$V1
            tras <- log(datos$V2)
            regresion <- lm(tras ~ x, data = datos)
            summary(regresion)
            curve(
              exp(regresion$coefficient[1]) * exp(regresion$coefficient[2] * x),
              add = T,
              col = "orange"
            )
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            tras <- log(datos$c2)
            regresion <- lm(tras ~ x, data = datos2)
            summary(regresion)
            curve(
              exp(regresion$coefficient[1]) * exp(regresion$coefficient[2] * x),
              add = T,
              col = "orange"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        
        if (expresion == "ln(y)=(ln(A)*x)+ln(B)" ||
            expresion == "y=A^x*B") {
          if (t == 2) {
            y <- datos$V2
            x <- datos$V1
            tras <- log(datos$V2)
            regresion <- lm(tras ~ x, data = datos)
            summary(regresion)
            curve(
              exp(regresion$coefficient[1]) * exp(regresion$coefficient[2]) ^ x,
              add = T,
              col = "gray"
            )
          }
          else{
            y <- datos2$c2
            x <- datos2$c1
            tras <- log(datos$c2)
            regresion <- lm(tras ~ x, data = datos2)
            summary(regresion)
            curve(
              exp(regresion$coefficient[1]) * exp(regresion$coefficient[2]) ^ x,
              add = T,
              col = "gray"
            )
          }
          output$modelSummary <- renderPrint({
            summary(regresion)
          })
        }
        
        
        
        
      
      })#isolate
    })#4
   
    #***************************fin formulas***************************************************
    
    
  })#3
 
  
  
})#1

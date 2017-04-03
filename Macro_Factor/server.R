#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
data(iris)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  # output$chart <- renderPlot({
  #   fit <- lm(Petal.Width ~ Petal.Length, data=iris)
  #   class(fit)
  #   coefficients(fit) # model coefficients
  #   predict(fit) # fitted predictions
  #   predict(fit, newdata=data.frame(Petal.Length=seq(1, 2, by=0.1)))
  #   confint(fit, level=0.95) # CIs for model parameters 
  #   fitted(fit) # predicted values
  #   residuals(fit) # residuals
  #   anova(fit) # anova table 
  #   influence(fit) # regression diagnostics
  #   par(mfrow=c(2,2))
  #   plot(fit)
  # 
  # })
  
})

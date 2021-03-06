library(shiny)
library(grDevices)
library(knitr)
#setwd("C:/Users/qase352/Dropbox/QuinnAsenaPhD/R/shiny/r_logistic")
ui <- fluidPage(
  h1("Deterministic Discrete Population Growth Models"), #Main page title
  tabsetPanel(
##################################################
#####     First tab for r growth model       #####
##################################################
    tabPanel("r discrete model",
             h1(includeHTML("r_model_title_text.html")),
  sidebarLayout(position = c("left"),
                sidebarPanel(
                  h4("Model Parameters"),
                
                sliderInput(inputId = "r_N",
                            label = "Starting Population (N)",
                            value = 10, min = 0, max = 100),
                sliderInput(inputId = "r_K",
                            label = "Carrying Capacity (K)",
                            value = 1000, min = 0, max = 5000),
                sliderInput(inputId = "r",
                            label = "Discrete Growth Rate (r)",
                            value = 0.05, min = -2, max = 4, step = 0.01, round = FALSE),
                sliderInput(inputId = "r_t",
                            label = "Time (t)",
                            value = 300, min = 0, max = 1000),
                h6(includeHTML("r_equation_guide.html"))
                ), #close sidebarPanel
                
            mainPanel(
            plotOutput("pop_plot"),
            plotOutput("pop_roc_plot")
            )
  )# close sidebarLayout
    ), #close tabPanel1
##################################################
#####  Second tab for labmda growth model    #####
##################################################
tabPanel("Lambda discrete model",
         h1(includeHTML("lambda_model_title_text.html")),
         sidebarLayout(position = c("left"),
                       sidebarPanel(
                         h4("Model Parameters"),
                         
                         sliderInput(inputId = "lambda_N",
                                     label = "Starting Population (N)",
                                     value = 10, min = 0, max = 100),
                         sliderInput(inputId = "lambda_K",
                                     label = "Carrying Capacity (K)",
                                     value = 1000, min = 0, max = 5000),
                         sliderInput(inputId = "lambda",
                                     label = "Finite Rate of Increase (lambda)",
                                     value = 1.09, min = -2, max = 4, step = 0.01, round = FALSE),
                         sliderInput(inputId = "lambda_t",
                                     label = "Time (t)",
                                     value = 200, min = 0, max = 1000),
                         h6(includeHTML("lambda_equation_guide.html"))
                       ), #close sidebarPanel
                       
                       mainPanel(
                         plotOutput("lambda_pop_plot"),
                         plotOutput("lambda_pop_roc_plot")
                       )
         )# close sidebarLayout
), #close tabPanel2
##################################################
#####   Third tab for model descriptions     #####
##################################################
tabPanel("Model descriptions",
         includeHTML("model_description.html"))# close tabPanel3

  ) #close tabsetPanel
) #close fluidPage
##################################################
#####              Functions                 #####
##################################################
# can be sourced from directory
##### function for r model (Nt+1 = Nt + rdNt * (1-Nt/K))
r_logistic.fun <- function(r = 0.05, K = 100, N_pop = 10, t = 100)
{
  N <- vector("numeric", length = t)
  N[1] <- N_pop
  for (i in 2:t)
  {
    N[i] <- N[i-1] + (r * N[i-1] * (1 - N[i-1] / K))   # version 2 with R
  }
  N <- ifelse(N <= 0, 0, N)
  return(N)
}
##### function for lambda model (Nt+1 = lambdaNt (1-Nt/K))
lambda_logistic.fun <- function(lambda = 1.2, K = 100, N_pop = 10, t = 100)
{
  N <- vector("numeric", length = t)
  N[1] <- N_pop
  for (i in 2:t)
  {
    N[i] <- lambda * N[i-1] * (1 - N[i-1] / K)   # version 2 with R
  }
  N <- ifelse(N <= 0, 0, N)
  return(N)
}
##### Function for rate of change (Nt - Nt+1)
pop_roc_fun <- function(pop_vec){
  for (i in length(pop_vec):2)
  {
    pop_vec[i] <- pop_vec[i] - pop_vec[i-1]
  }
  pop_vec[1] <- NA
  return(pop_vec)
}
##################################################
#####                Outputs                 #####
##################################################
# Create reactive data from function so input values are the same for both following plots and update dynamically
server <- function(input, output){
  r_logistic_data <- reactive({
    r_logistic.fun(r = input$r, K = input$r_K, N_pop = input$r_N, t=input$r_t)
  })
  # Plot logistic function  
  output$pop_plot <- renderPlot(
    if (input$r > 2.45){
    plot(r_logistic_data(),
         type = 'l', lwd = 1, col = 'red', ylab = 'Population size (N)', xlab='Time', 
         cex.lab = 1, cex.axis = 1)
    } else {
      plot(r_logistic_data(),
           type = 'l', lwd = 1, col = 'darkblue', ylab = 'Population size (N)', xlab='Time', 
           cex.lab = 1, cex.axis = 1)
    }
  )
    
  # Plot rate of change function  
  output$pop_roc_plot <- renderPlot(
    plot(y = pop_roc_fun(r_logistic_data()), x = r_logistic_data(),
         type = 'l', lwd = 1, col = 'darkblue', ylab = expression(paste("Change in population (",Delta, "Nt)")), xlab='Population size (N)', 
         cex.lab = 1, cex.axis = 1))
##################################################
  # Create reactive data from function so input values are the same for both following plots and update dynamically
  lambda_logistic_data <- reactive({
    lambda_logistic.fun(lambda = input$lambda, K = input$lambda_K, N_pop = input$lambda_N, t=input$lambda_t)
  })
  # Plot logistic function    
  output$lambda_pop_plot <- renderPlot(
    plot(lambda_logistic_data(),
         type = 'l', lwd = 1, col = 'darkblue', ylab = 'Population size (N)', xlab='Time', 
         cex.lab = 1, cex.axis = 1)
  )
  # Plot rate of change function  
  output$lambda_pop_roc_plot <- renderPlot(
    plot(y = pop_roc_fun(lambda_logistic_data()), x = lambda_logistic_data(),
         type = 'l', lwd = 1, col = 'darkblue', ylab = expression(paste("Change in population (",Delta, "Nt)")), xlab='Population size (N)', 
         cex.lab = 1, cex.axis = 1))
}

shinyApp(ui = ui, server = server)


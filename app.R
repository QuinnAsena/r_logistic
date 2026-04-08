library(shiny)

# ── Model functions ──────────────────────────────────────────────────────────

#' Discrete logistic growth using r_d
#' Nt+1 = Nt + r_d * Nt * (1 - Nt / K)
r_logistic <- function(r, K, N0, t) {
  if (t < 1) return(numeric(0))
  N <- numeric(t)
  N[1] <- N0
  if (t >= 2 && K > 0) {
    for (i in 2:t) {
      N[i] <- N[i - 1] + r * N[i - 1] * (1 - N[i - 1] / K)
    }
  }
  pmax(N, 0)
}

#' Discrete logistic growth using lambda
#' Nt+1 = lambda * Nt * (1 - Nt / K)
lambda_logistic <- function(lambda, K, N0, t) {
  if (t < 1) return(numeric(0))
  N <- numeric(t)
  N[1] <- N0
  if (t >= 2 && K > 0) {
    for (i in 2:t) {
      N[i] <- lambda * N[i - 1] * (1 - N[i - 1] / K)
    }
  }
  pmax(N, 0)
}

#' Rate of change: delta_N[t] = N[t+1] - N[t]
rate_of_change <- function(N) {
  c(NA_real_, diff(N))
}

# ── UI ───────────────────────────────────────────────────────────────────────

ui <- fluidPage(
  withMathJax(),
  h1("Deterministic Discrete Population Growth Models"),
  tabsetPanel(

    # ── Tab 1: r model ────────────────────────────────────────────────────────
    tabPanel(
      "r discrete model",
      h1(includeHTML("r_model_title_text.html")),
      sidebarLayout(
        sidebarPanel(
          h4("Model Parameters"),
          sliderInput("r_N", "Starting Population (N)",
                      value = 10, min = 0, max = 100),
          sliderInput("r_K", "Carrying Capacity (K)",
                      value = 1000, min = 1, max = 5000),
          sliderInput("r", "Discrete Growth Rate (r)",
                      value = 0.05, min = -2, max = 4,
                      step = 0.01, round = FALSE),
          sliderInput("r_t", "Time (t)",
                      value = 300, min = 1, max = 1000),
          h6(includeHTML("r_equation_guide.html"))
        ),
        mainPanel(
          plotOutput("r_pop_plot"),
          plotOutput("r_roc_plot")
        )
      )
    ),

    # ── Tab 2: lambda model ──────────────────────────────────────────────────
    tabPanel(
      "Lambda discrete model",
      h1(includeHTML("lambda_model_title_text.html")),
      sidebarLayout(
        sidebarPanel(
          h4("Model Parameters"),
          sliderInput("lambda_N", "Starting Population (N)",
                      value = 10, min = 0, max = 100),
          sliderInput("lambda_K", "Carrying Capacity (K)",
                      value = 1000, min = 1, max = 5000),
          sliderInput("lambda", "Finite Rate of Increase (lambda)",
                      value = 1.09, min = -2, max = 4,
                      step = 0.01, round = FALSE),
          sliderInput("lambda_t", "Time (t)",
                      value = 200, min = 1, max = 1000),
          h6(includeHTML("lambda_equation_guide.html"))
        ),
        mainPanel(
          plotOutput("lambda_pop_plot"),
          plotOutput("lambda_roc_plot")
        )
      )
    ),

    # ── Tab 3: descriptions ──────────────────────────────────────────────────
    tabPanel("Model descriptions", includeHTML("model_description.html"))
  )
)

# ── Server ───────────────────────────────────────────────────────────────────

server <- function(input, output) {

  # Reactive data for the r model
  r_data <- reactive({
    r_logistic(r = input$r, K = input$r_K, N0 = input$r_N, t = input$r_t)
  })

  # Population vs time (r model) — red when chaotic
  output$r_pop_plot <- renderPlot({
    N <- r_data()
    line_col <- if (input$r > 2.45) "red" else "darkblue"
    plot(N, type = "l", lwd = 1.2, col = line_col,
         xlab = "Time", ylab = "Population size (N)",
         cex.lab = 1.2, cex.axis = 1.1)
  })

  # Rate-of-change vs population (r model)
  output$r_roc_plot <- renderPlot({
    N <- r_data()
    dN <- rate_of_change(N)
    plot(N, dN, type = "l", lwd = 1.2, col = "darkblue",
         xlab = "Population size (N)",
         ylab = expression(paste("Change in population (", Delta, "N)")),
         cex.lab = 1.2, cex.axis = 1.1)
  })

  # Reactive data for the lambda model
  lambda_data <- reactive({
    lambda_logistic(lambda = input$lambda, K = input$lambda_K,
                    N0 = input$lambda_N, t = input$lambda_t)
  })

  # Population vs time (lambda model) — red when chaotic
  output$lambda_pop_plot <- renderPlot({
    N <- lambda_data()
    line_col <- if (input$lambda > 3.0) "red" else "darkblue"
    plot(N, type = "l", lwd = 1.2, col = line_col,
         xlab = "Time", ylab = "Population size (N)",
         cex.lab = 1.2, cex.axis = 1.1)
  })

  # Rate-of-change vs population (lambda model)
  output$lambda_roc_plot <- renderPlot({
    N <- lambda_data()
    dN <- rate_of_change(N)
    plot(N, dN, type = "l", lwd = 1.2, col = "darkblue",
         xlab = "Population size (N)",
         ylab = expression(paste("Change in population (", Delta, "N)")),
         cex.lab = 1.2, cex.axis = 1.1)
  })
}

shinyApp(ui = ui, server = server)


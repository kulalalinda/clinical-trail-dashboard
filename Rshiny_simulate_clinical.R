library(shiny)
library(tidyverse)
library(lubridate)
library(DT)
library(shinydashboard)

# Simulate data for KroniKare-style wound monitoring
set.seed(123)
n_patients <- 100

patients <- tibble(
  patient_id = sprintf("P%03d", 1:n_patients),
  age = sample(40:90, n_patients, replace = TRUE),
  sex = sample(c("Male", "Female"), n_patients, replace = TRUE),
  wound_type = sample(c("Diabetic Ulcer", "Pressure Ulcer", "Venous Ulcer"), n_patients, replace = TRUE),
  wound_location = sample(c("Leg", "Foot", "Back", "Hip"), n_patients, replace = TRUE),
  initial_severity = sample(1:5, n_patients, replace = TRUE),
  ai_care_plan = sample(c("Dressing A", "Dressing B", "Antibiotics", "Debridement"), n_patients, replace = TRUE)
)

# Simulate wound healing over 12 weeks
healing_data <- map_df(1:n_patients, function(i) {
  weeks <- 0:12
  severity <- pmax(0, patients$initial_severity[i] - cumsum(runif(13, 0.1, 0.5)))
  tibble(
    patient_id = patients$patient_id[i],
    week = weeks,
    wound_severity = round(severity, 1),
    infection_status = sample(c("None", "Mild", "Severe"), 13, replace = TRUE, prob = c(0.7, 0.25, 0.05))
  )
})

ui <- dashboardPage(
  dashboardHeader(title = "KroniKare Clinical Trial Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Patient Data", tabName = "patient", icon = icon("users")),
      menuItem("Healing Progress", tabName = "healing", icon = icon("heartbeat"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidRow(
                box(title = "Patient Summary", width = 6, DTOutput("summary_table")),
                box(title = "Wound Type Distribution", width = 6, plotOutput("wound_type_plot"))
              )
      ),
      tabItem(tabName = "patient",
              fluidRow(
                box(title = "Patient Details", width = 12, DTOutput("patient_table"))
              )
      ),
      tabItem(tabName = "healing",
              fluidRow(
                box(title = "Select Patient", width = 4,
                    selectInput("selected_patient", "Patient ID:", choices = patients$patient_id)),
                box(title = "Healing Trend", width = 8, plotOutput("healing_plot"))
              )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$summary_table <- renderDT({
    patients %>%
      count(wound_type, sex) %>%
      pivot_wider(names_from = sex, values_from = n, values_fill = 0)
  })
  
  output$wound_type_plot <- renderPlot({
    patients %>%
      count(wound_type) %>%
      ggplot(aes(x = wound_type, y = n, fill = wound_type)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Wound Type Distribution", y = "Count", x = NULL) +
      scale_fill_brewer(palette = "Set2")
  })
  
  output$patient_table <- renderDT({
    datatable(patients)
  })
  
  output$healing_plot <- renderPlot({
    healing_data %>%
      filter(patient_id == input$selected_patient) %>%
      ggplot(aes(x = week, y = wound_severity, color = infection_status)) +
      geom_line(size = 1.2) +
      geom_point() +
      theme_minimal() +
      labs(title = paste("Healing Progress for", input$selected_patient),
           x = "Week", y = "Wound Severity") +
      scale_color_manual(values = c("None" = "green", "Mild" = "orange", "Severe" = "red"))
  })
  
}

shinyApp(ui, server)


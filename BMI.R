library(shiny)

ui <- fluidPage(
  titlePanel("BMI Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("weight", "Weight (kg):", value = 70, min = 30, max = 200),
      numericInput("height", "Height (cm):", value = 170, min = 100, max = 250),
      actionButton("calc", "Calculate BMI")
    ),
    
    mainPanel(
      verbatimTextOutput("bmi"),
      verbatimTextOutput("status")
    )
  )
)

server <- function(input, output){
  observeEvent(input$calc,{
    height_m <- input$height / 100
    bmi_value <- input$weight / (height_m^2)
    
    output$bmi <- renderText({
      paste("Your BMI is:", round(bmi_value, 2))
    })
    
    output$status <- renderText({
      if (bmi_value < 18.5) {
        "Status: Underweight"
      } else if (bmi_value < 24.9) {
        "Status: Normal weight"
      } else if (bmi_value < 29.9) {
        "Status: Overweight"
      } else {
        "Status: Obese"
      }
    })
  })
}

shinyApp(ui, server)

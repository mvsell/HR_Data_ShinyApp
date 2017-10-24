shinyUI(fluidPage(
       titlePanel("Predict which employee is likely to leave the Company next"),
        sidebarLayout(
                sidebarPanel(
                        textInput("satisfaction_level", "Satisfaction Level", 0.11),
                        sliderInput("number_project","Number of Projects", min = 2, max = 10, value = 4),
                        sliderInput("time_spend_company","Time Spent at the Company", min = 1, max = 15, value = 3),
                        textInput("average_montly_hours", "Average Monthly Hours Worked", 160),
                        textInput("last_evaluation", "Last Evaluation", 0.60),
                        submitButton("Submit")
                ),
                mainPanel(
                        h4("Predicted result:"),
                        textOutput("out")
                )
                
        )
)
)
        
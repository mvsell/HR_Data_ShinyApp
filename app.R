#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stats)
library(caret)
library(lattice)
library(ggplot2)
library(gbm)
library(survival)
library(plyr)
library(e1071)

# library(stats)
# library(mlbench)
# library(gbm)
# library(rpart)
# library(ggfortify)
# library(plotly)
# library(leaflet)

# hr<-read.csv("./Data/HR_comma_sep_ed.csv")
hr<-readRDS("./Data/hr.RDS")
# Make sure computations can be reproducible.
set.seed(123)
# Partition data- this will increase performance not to take the entire data
inTrainSet <- createDataPartition(y=hr$left, p=0.5, list=FALSE)
training <- hr[inTrainSet,]
# Train learning model
fitControl<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
fit <- train(as.factor(left)~satisfaction_level+number_project+time_spend_company+average_montly_hours+last_evaluation, 
             data = training, trControl=fitControl, method="gbm")


# Define UI for application that draws a histogram
ui <- fluidPage(
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

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # Reactive expression called whenever inputs change.
  model1pred<-reactive({
    new_data=as.data.frame(matrix(0, nrow=1, ncol=5))
    colnames(new_data)=c("satisfaction_level", "last_evaluation", "number_project", 
                         "average_montly_hours", "time_spend_company")
    new_data[1,1]=as.numeric(input$satisfaction_level)
    new_data[1,2]=as.numeric(input$last_evaluation)
    new_data[1,3]=as.numeric(input$number_project)
    new_data[1,4]=as.numeric(input$average_montly_hours)
    new_data[1,5]=as.numeric(input$time_spend_company)
    predict(fit, newdata=new_data)
  })
  
  # Fill-in the tabs with output from caret
  output$out <- renderPrint({
    if(model1pred()=="1") print("Leaves the Company")
    else print("Stays in the Company")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


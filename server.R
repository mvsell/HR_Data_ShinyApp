library(shiny)
library(dplyr)
library(caret)
library(stats)
library(mlbench)
library(gbm)
library(rpart)
library(ggfortify)
library(plotly)
library(leaflet)



        hr<-read.csv("HR_comma_sep.csv", header = T)
        # Make sure computations can be reproducible.
        set.seed(123)
        # Partition data- this will increase performance not to take the entire data
        inTrainSet <- createDataPartition(y=hr$left, p=0.5, list=FALSE)
        training <- hr[inTrainSet,]
        # Train learning model
        fitControl<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
        fit <- train(as.factor(left)~satisfaction_level+number_project+time_spend_company+average_montly_hours+last_evaluation, 
                     data = training, trControl=fitControl, method="gbm")

# Server logic
shinyServer(function(input, output) {
        
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

})

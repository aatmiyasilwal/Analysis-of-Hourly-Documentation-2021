#libraries
library(datasets)
library(randomForest)
library(cowplot)
library(repr)
library(dslabs)
library(tidyr)
library(dplyr)
library(rvest)
library(stringr)
library(lubridate)
library(gutenbergr)
library(tidytext)
library(textdata)
library(ggplot2)
library(ggrepel)
library(purrr)
library(datasets)
library(caret)

#importing the dataset
data <- read.csv("C:/Users/Aatmiya Silwal/Desktop/Hourly_Documentation_CSV.csv")

for (i in 1:length(colnames(data))){
  if (substr(colnames(data)[i], 1, 1) == "X"){
    colnames(data)[i]<- substr(colnames(data)[i], 2,6)
  }
}

#converting categorical data into factors
data$Day <- as.factor(data$Day)
data$Month <- as.factor(data$Month)
data$Season <- as.factor(data$Season)
data$`0.00` <- as.factor(data$`0.00`)
data$`0.30` <- as.factor(data$`0.30`)
data$`1.00` <- as.factor(data$`1.00`)
data$`1.30` <- as.factor(data$`1.30`)
data$`2.00` <- as.factor(data$`2.00`)
data$`2.30` <- as.factor(data$`2.30`)
data$`3.00` <- as.factor(data$`3.00`)
data$`3.30` <- as.factor(data$`3.30`)
data$`4.00` <- as.factor(data$`4.00`)
data$`4.30` <- as.factor(data$`4.30`)
data$`5.00` <- as.factor(data$`5.00`)
data$`5.30` <- as.factor(data$`5.30`)
data$`6.00` <- as.factor(data$`6.00`)
data$`6.30` <- as.factor(data$`6.30`)
data$`7.00` <- as.factor(data$`7.00`)
data$`7.30` <- as.factor(data$`7.30`)
data$`8.00` <- as.factor(data$`8.00`)
data$`8.30` <- as.factor(data$`8.30`)
data$`9.00` <- as.factor(data$`9.00`)
data$`9.30` <- as.factor(data$`9.30`)
data$`10.00` <- as.factor(data$`10.00`)
data$`10.30` <- as.factor(data$`10.30`)
data$`11.00` <- as.factor(data$`11.00`)
data$`11.30` <- as.factor(data$`11.30`)
data$`12.00` <- as.factor(data$`12.00`)
data$`12.30` <- as.factor(data$`12.30`)
data$`13.00` <- as.factor(data$`13.00`)
data$`13.30` <- as.factor(data$`13.30`)
data$`14.00` <- as.factor(data$`14.00`)
data$`14.30` <- as.factor(data$`14.30`)
data$`15.00` <- as.factor(data$`15.00`)
data$`15.30` <- as.factor(data$`15.30`)
data$`16.00` <- as.factor(data$`16.00`)
data$`16.30` <- as.factor(data$`16.30`)
data$`17.00` <- as.factor(data$`17.00`)
data$`17.30` <- as.factor(data$`17.30`)
data$`18.00` <- as.factor(data$`18.00`)
data$`18.30` <- as.factor(data$`18.30`)
data$`19.00` <- as.factor(data$`19.00`)
data$`19.30` <- as.factor(data$`19.30`)
data$`20.00` <- as.factor(data$`20.00`)
data$`20.30` <- as.factor(data$`20.30`)
data$`21.00` <- as.factor(data$`21.00`)
data$`21.30` <- as.factor(data$`21.30`)
data$`22.00` <- as.factor(data$`22.00`)
data$`22.30` <- as.factor(data$`22.30`)
data$`23.00` <- as.factor(data$`23.00`)
data$`23.30` <- as.factor(data$`23.30`)


#setting up data using pivot longer
exclusions <- c("Day", "Month", "Date", "Season")
data <- data |> pivot_longer(cols=-one_of(exclusions), names_to = "Time", values_to = "Activity") |> as.data.frame()
data$Time <- as.factor(data$Time)
head(data, 30)

#setting seed for reproducibility and splitting data into train and test data
set.seed(24)
train_idx <- createDataPartition(data$Activity, p = 0.7, list = FALSE)
train <- data[train_idx, ]
test <- data[-train_idx, ]

#creating a random forest model
rf_model <- randomForest(Activity~., data=test, proximity=TRUE, ntree=500)
print(rf_model)

#checking accuracy of model
predicted <- predict(rf_model, newdata = test)
accuracy <- sum(predicted == test$Activity) / nrow(test)

print(paste0("Accuracy: ", accuracy))

#display graph highlighting significance of variables
varImpPlot(rf_model)

#check for class error, and see how that changes as the number of trees increases
oob.error.data <- data.frame(
  Trees=rep(1:nrow(rf_model$err.rate), times=3),
  Type=rep(c("1", "5", "11"), each=nrow(rf_model$err.rate)),
  Error=c(rf_model$err.rate[,"1"],
           rf_model$err.rate[,"5"],
           rf_model$err.rate[,"11"])
)

ggplot(data=oob.error.data, aes(x=Trees, y=Error)) + geom_line(aes(color=Type), size=2.2)

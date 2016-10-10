# this r script tidy's data from the Human Activity Recognition Using Smartphones Data Set
# For more info See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Auther Glen Shiery
# 
# 1) combines testing and training data from machine learning example
# 2) presents only means and standard deviations
# 3) Creates tidy data output file in working diretory
# 4) Set the working direcory to location of your data. (see line 20)


install.packages("dplyr");library(dplyr)
install.packages("tidyr"); library(tidyr)

library(reshape2 )
library(data.table)


# set working directory
#   Alter this to point to your working directory
setwd("K://UCI HAR Dataset/")

# Read common data

#Read activity lables from file
activityLabels <- read.table(".//activity_labels.txt")
activityLabels <- activityLabels[,2]

#  read column names from file
features <- read.table("./features.txt")
features <-features[,2]

# grep for mean and stdev 
meanStd_features <- grepl("mean|std", features)


# Combine like parts
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")


# Read subject test file
subjectTest <- read.table("./test/subject_test.txt")

#set column names  in xTest
names(xTest) = features

#leave only means and standard deviation columns
xTest = xTest[,meanStd_features]

#add activity lables column
yTest <- mutate(yTest,activityLabels[yTest[,1]])

# add column headers
names(yTest) = c("Activity_ID", "Activity_Label")
names(subjectTest) = "subject"

#combine data frames based on columns
testData <- cbind(subjectTest, yTest, xTest)


# Do it all again with Training data


#read training data
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")

# set header for x training
names(xTrain) = features

#leave only means and standard deviation columns
xTrain = xTrain[,meanStd_features]

#add activity lables column
yTrain <- mutate(yTrain,activityLabels[yTrain[,1]])

#add activity id, activity lable and subject headers
names(yTrain) = c("Activity_ID", "Activity_Label")
names(subjectTrain) = "subject"

#column combine all training data
trainData <- cbind(subjectTrain, yTrain, xTrain)

#column combine  test and training data
allData = rbind(testData, trainData)

#add columns subject, activity id and activity lable 
idLabels = c("subject", "Activity_ID", "Activity_Label")

# add new columns to list of headers
dataLabels = setdiff(colnames(allData), idLabels)

# melt / convert column(id) data to measure data
meltData = melt(allData, id = idLabels, measure.vars = dataLabels)

#create tidy data
tidy_data = dcast(meltData, subject + Activity_Label ~ variable, mean)

# write to file
write.table(tidy_data, file = "./Mytidy_data.txt", row.name=FALSE )

---
title: "CodeBook.md"
output: html_document
---
# This script reads the data from the local directory.
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Clean up workspace as a best practice to free up memory
## rm(list=ls())
## rm(subjectTrain, xTrain, yTrain)

# Variables
## directory : current working directory
## dataDir : data directory
## testDir : test data directory
## trainDir : train data directory

## features : data table with  columns "featureId" "featureLabel" read from features.txt
## activityLabels : data table with columns "activityId","activityType" read from activity_labels.txt

## subjectTrain : data table read from subject_train.txt
## xTrain : data table read from x_train.txt"
## yTrain : data table read from y_train.txt
## trainData : data table merged training data

## subjectTest : data table read from subject_test.txt
## xTest : data table read from x_test.txt
## yTest : data table read from y_test.txt
## testData : data table merged test data

# 1. Merge the training and the test sets to create one data set.
## mergeData : merged data table from testData and trainData

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
## meanstddevData : merged data containing only columns with mean and std strings

# 3. Use descriptive activity names to name the activities in the data set
## meanstddevData : merged data containing only columns with mean and std strings and activityLabels

# 4: Appropriately labels the data set with descriptive activity names 
## remove all () and - in columns in table data meanstddevData

# 5. Creates a second, independent tidy data set with the average of each variable 
## newtidyData : new and independent table data 
## finally write to newtidyData.csv

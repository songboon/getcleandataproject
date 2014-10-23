# This script reads the data from the local directory.
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Clean up workspace as a best practice to free up memory
rm(list=ls())

# load all the relevant library
library(data.table)

# set my directory path correct
directory <- getwd()
dataDir <- "UCI HAR Dataset"
testDir <- paste(directory, "UCI HAR Dataset/test", sep="/")
trainDir <- paste(directory, "UCI HAR Dataset/train", sep="/")

# load base data 
features = read.table(paste(dataDir, "features.txt", sep="/"),header=FALSE, col.names=c("featureId", "featureLabel"))
activityLabels = read.table(paste(dataDir, "activity_labels.txt", sep="/"),header=FALSE, col.names=c("activityId","activityType"))

# load training data                       
subjectTrain = read.table(paste(trainDir, "subject_train.txt", sep="/"),header=FALSE, col.names=c("subjectId"))
subjectTrain$ID = as.numeric(rownames(subjectTrain))
xTrain = read.table(paste(trainDir, "x_train.txt", sep="/"),header=FALSE)
xTrain$ID = as.numeric(rownames(xTrain))
yTrain = read.table(paste(trainDir, "y_train.txt", sep="/"),header=FALSE, col.names=c("activityId"))
yTrain$ID = as.numeric(rownames(yTrain))

# merge all together into one training data set
trainData = merge(subjectTrain, yTrain, all=TRUE)
trainData = merge(trainData, xTrain, all=TRUE)

# clean up memory
rm(subjectTrain, xTrain, yTrain)

# load test data
subjectTest = read.table(paste(testDir, "subject_test.txt", sep="/"),header=FALSE, col.names=c("subjectId"))
subjectTest$ID = as.numeric(rownames(subjectTest))
xTest = read.table(paste(testDir, "x_test.txt", sep="/"),header=FALSE)
xTest$ID = as.numeric(rownames(xTest))
yTest = read.table(paste(testDir, "y_test.txt", sep="/"),header=FALSE, col.names=c("activityId"))
yTest$ID = as.numeric(rownames(yTest))

# merge all together into one test data set
testData = merge(subjectTest, yTest, all=TRUE)
testData = merge(testData, xTest, all=TRUE)

# clean up memory
rm(subjectTest, xTest, yTest)

# 1. Merge the training and the test sets to create one data set.
mergeData = rbind(testData, trainData)

# clean up memory
rm(testData, trainData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# select only column names with mean and standard deviation labels
selectedFeatures = features[grepl("mean\\(\\)", features$featureLabel) | grepl("std\\(\\)", features$featureLabel), ]
# select only corresponding columns with selectFeatures including the 1st 3 columns from mergeData
meanstddevData = mergeData[, c(c(1, 2, 3), selectedFeatures$featureId + 3) ]

# clean up memory
rm(mergeData)

# 3. Use descriptive activity names to name the activities in the data set
meanstddevData = merge(meanstddevData, activityLabels)

# 4: Appropriately labels the data set with descriptive activity names 

# global remove all brackets under featureLabel column
selectedFeatures$featureLabel = gsub("\\(\\)", "", selectedFeatures$featureLabel)
# global replace all - with . under featureLabel column
selectedFeatures$featureLabel = gsub("-", ".", selectedFeatures$featureLabel)

# assign the feature labels to each corresponding columns V* of meanstddevData 
for (i in 1:length(selectedFeatures$featureLabel)) {
  colnames(meanstddevData)[i + 3] = selectedFeatures$featureLabel[i]
}

# 5. Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject. 

# Remove columns ID and activityType they are used as reference keys
# otherwise aggregate function will cause warnings
columnstodrop = c("ID","activityType")
newtidyData = meanstddevData[,!(names(meanstddevData) %in% columnstodrop)]

# clean up memory
rm(meanstddevData, features)

# Compute the mean for each subject ID and each activity ID
newtidyData = aggregate(newtidyData, by=list(subject=newtidyData$subjectId, activity=newtidyData$activityId), FUN=mean, na.rm=TRUE)

# Put back the activity type string
newtidyData = merge(activityLabels, newtidyData)

# Remove columns subject and activity as they are redundant data created by the aggregate function above
columnstodrop = c("subject","activity", "activityId")
newtidyData = newtidyData[,!(names(newtidyData) %in% columnstodrop)]

# output the final result to csv file format in current working directory
if(file.exists("newtidyData.csv")) {
  file.remove("newtidyData.csv")
}
write.csv(newtidyData, "newtidyData.csv")

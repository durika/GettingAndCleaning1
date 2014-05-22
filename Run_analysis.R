library(data.table)
setwd("git/gettingandcleaning1")
if(!file.exists("dataset.zip")) download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  "dataset.zip")
unzip("dataset.zip")

tempData <- fread("UCI HAR Dataset/test/x_test.txt", sep="\n",header=FALSE)
setnames(tempData,names(tempData), "col")
set(tempData, i=NULL, j=1L, value=sub(",","",gsub(" ",",",gsub("  "," ", tempData[[1]]))))
write.table(tempData, "UCI HAR Dataset/test/x_test.csv",
            row.names=FALSE, col.names=FALSE,quote = FALSE)

tempData <- fread("UCI HAR Dataset/train/x_train.txt", sep="\n",header=FALSE)
setnames(tempData,names(tempData), "col")
set(tempData, i=NULL, j=1L, value=sub(",","",gsub(" ",",",gsub("  "," ", tempData[[1]]))))
write.table(tempData, "UCI HAR Dataset/train/x_train.csv",
            row.names=FALSE, col.names=FALSE,quote = FALSE)

rm(tempData)

features <- fread("UCI HAR Dataset/features.txt", sep=" ",header=FALSE)
activities <- fread("UCI HAR Dataset/activity_labels.txt", sep=" ",header=FALSE)

testData <- fread("UCI HAR Dataset/test/x_test.csv", sep=",",header=FALSE)
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testActivities <- fread("UCI HAR Dataset/test/y_test.txt",header=FALSE)

trainData <- fread("UCI HAR Dataset/train/x_train.csv", sep=",",header=FALSE)
trainSubjects <- fread("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainActivities <- fread("UCI HAR Dataset/train/y_train.txt",header=FALSE)

oldTestNames <- names(testData)
oldTrainNames <- names(trainData)

setnames(features,names(features),c("rowno","feature"))
setnames(activities,names(activities),c("activityid","activity"))


setnames(testSubjects,names(testSubjects),"subjectid")
setnames(testActivities,names(testActivities),"activityid")

setnames(trainSubjects,names(trainSubjects),"subjectid")
setnames(trainActivities,names(trainActivities),"activityid")

testData <- cbind(testData, testActivities, testSubjects)
testData <- merge(testData,activities, by="activityid")
tempData <- data.table("test")
setnames(tempData,names(tempData),"type")
testData <- cbind(testData, tempData)
  
trainData <- cbind(trainData, trainActivities, trainSubjects)
trainData <- merge(trainData,activities, by="activityid")
tempData <- data.table("train")
setnames(tempData,names(tempData),"type")
trainData <- cbind(trainData, tempData)

rm(tempData)
rm(activities)
rm(testActivities)
rm(trainActivities)
rm(testSubjects)
rm(trainSubjects)

setnames(testData,oldTestNames,features[["feature"]])
setnames(trainData,oldTrainNames,features[["feature"]])
colList <- features[feature %like% "std" | feature %like% "mean"][["feature"]]

rm(oldTestNames)
rm(oldTrainNames)
rm(features)

myData <- rbindlist(list
                    (testData[,c("type","activity","subjectid",colList),with=FALSE],
                     trainData[,c("type","activity","subjectid",colList),with=FALSE]))
rm(testData)
rm(trainData)
rm(colList)

tidyData <- myData[, lapply(.SD, mean), by = c("type","activity","subjectid")]

rm(myData)
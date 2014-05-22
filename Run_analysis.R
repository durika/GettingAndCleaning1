#1.0. Loading libraries
library(data.table)

#1.1. Preprocessing the data - this is faster than read.table
tempData <- fread("UCI HAR Dataset/test/x_test.txt", sep="\n",header=FALSE)
set(tempData, i=NULL, j=1L, value=sub(",","",gsub(" ",",",gsub("  "," ", tempData[[1]]))))
write.table(tempData, "UCI HAR Dataset/test/x_test.csv",
            row.names=FALSE, col.names=FALSE,quote = FALSE)

tempData <- fread("UCI HAR Dataset/train/x_train.txt", sep="\n",header=FALSE)
set(tempData, i=NULL, j=1L, value=sub(",","",gsub(" ",",",gsub("  "," ", tempData[[1]]))))
write.table(tempData, "UCI HAR Dataset/train/x_train.csv",
            row.names=FALSE, col.names=FALSE,quote = FALSE)

#We will not need this
rm(tempData)

#1.2. Load all necessary files to data.table objects
features <- fread("UCI HAR Dataset/features.txt", sep=" ",header=FALSE)
activities <- fread("UCI HAR Dataset/activity_labels.txt", sep=" ",header=FALSE)

testData <- fread("UCI HAR Dataset/test/x_test.csv", sep=",",header=FALSE)
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testActivities <- fread("UCI HAR Dataset/test/y_test.txt",header=FALSE)

trainData <- fread("UCI HAR Dataset/train/x_train.csv", sep=",",header=FALSE)
trainSubjects <- fread("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainActivities <- fread("UCI HAR Dataset/train/y_train.txt",header=FALSE)

#1.3. store the default column names for future use
oldTestNames <- names(testData)
oldTrainNames <- names(trainData)

#1.4. set the proper columnnames in lookup and join datasets
setnames(features,names(features),c("rowno","feature"))
setnames(activities,names(activities),c("activityid","activity"))

setnames(testSubjects,names(testSubjects),"subjectid")
setnames(testActivities,names(testActivities),"activityid")

setnames(trainSubjects,names(trainSubjects),"subjectid")
setnames(trainActivities,names(trainActivities),"activityid")

#2.1 Merge the datasets with activities and subject datasets
#including the lookup dataset for both train and test data
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

#We will not need this
rm(tempData)
rm(activities)
rm(testActivities)
rm(trainActivities)
rm(testSubjects)
rm(trainSubjects)

#3.1. Set the proper columnnames for the main dataset
setnames(testData,oldTestNames,features[["feature"]])
setnames(trainData,oldTrainNames,features[["feature"]])
colList <- features[feature %like% "std" | feature %like% "mean"][["feature"]]

#We will not need this
rm(oldTestNames)
rm(oldTrainNames)
rm(features)

#4.1. Merge the two main datasest
myData <- rbindlist(list
                    (testData[,c("type","activity","subjectid",colList),with=FALSE],
                     trainData[,c("type","activity","subjectid",colList),with=FALSE]))

#We will not need this
rm(testData)
rm(trainData)
rm(colList)

#5.1. Calculate averages of all needed metrics and write to a file
tidyData <- myData[, lapply(.SD, mean), by = c("type","activity","subjectid")]
write.table(tidyData, "avg_sensor_measures.csv", sep=",", row.names=FALSE)
rm(myData)
##Readme file for Run_analysis.R
You can get the dataset to run the analysis from R by this code:  
download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  "dataset.zip")
unzip("dataset.zip")

Then you can run Run_analysis.R (providing the file is in your working directory):  
source(Run_analysis.R)

Output of all the average metrics that contain std or mean in their names (refer to features.txt in the zipfile) groupped by test subjects,
activity names and type(test,train) is saved to file avg_sensor_measures.txt

Please refer to CodeBook.md for details.
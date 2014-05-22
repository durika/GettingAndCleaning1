##Hello, this file describes functionality of Run_analysis.md
The script's functionality is to work on Samsung sensor data, process it and output a file of average metrics for each subject, test type and activity.
Package data.table is utilized for better performance
Data used can be download from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The dataset contains multiple files, some of which are to describe the data itself, please refer to the files directly in "UCI HAR Dataset" folder of the
 zipped file for details.

Script execution can be divided into 5 logical steps (with step 0 containing 5 sub steps), these can be described:  

###Step 1. - Preprocessing:  
-    1.0. Loads required package data.table into the library  
-		1.1. Process x_test.txt and x_train.txt files into csv files and writes them in x_test.csv and x_train.csv in their respective folders  
-		1.2. Load all necessary files to data.table objects. Creates following data.table objects:  
			features - contains names of all metrics  
			activities - lookup table for activities  
			testData - main dataset for test subset  
			testSubjects - test subjects for testData  
			testActivities - test activities for testData  
			trainData - main dataset for train subset  
			trainSubjects - test subjects for trainData  
			trainActivities - test activities for trainData  
-		1.3. Store the default column names for future use:  
			oldTestNames - column names of testData  
			oldTrainNames - column names of trainData  
-		1.4. Sets the proper column names for all datasets except the main datasets (testData, trainData)  

###Step 2. - Merge the datasets with activities and subject datasets:  
-		2.1. This step does not merge the test and train datasets, instead we merge both main datasets to their respective activities and testsubject datasets.  
		The merged results are stored in the original respective datasets (testData, trainData).  
    
###Step 3. - Set the proper column names for the main dataset  
-		3.1. Here we make use of the oldTestNames and oldTrainNames from step 1.3. to set the column names of the metrics properly  

###Step 4. - Merge the main datasets  
-		4.1. We merge the two main datasets (testData, trainData) using rbindlist and store the result in myData data.table 

###Step 5. - Calculate averages of all needed metrics and write to a file  
-		5.1. Finally, averages for all metrics are calculated and written to avg_sensor_measures.txt file  
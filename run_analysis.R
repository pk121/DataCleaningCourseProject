#To test the script, set the working directory to any custome folder manually.

#loading packages
library(dplyr)
library(readr)

#creating temporary file to download data
temp<-tempfile()
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,temp,mode="wb")

#We unzip the file in current working directory
unzip(temp,exdir=".")
unlink(temp)

# readind 'features.txt'
features<-read.table("UCI HAR Dataset/features.txt",sep=" ")

# reading 'X_test.txt', 'y_test.txt' & 'subject_test.txt'
testValues<-read_table("UCI HAR Dataset/test/X_test.txt",col_names=as.character(features$V2))
testLabels<-read_table("UCI HAR Dataset/test/y_test.txt",col_names="Activity")
testSubjects<-read_table("UCI HAR Dataset/test/subject_test.txt",col_names="Subject")

# reading 'X_train.txt', 'y_train.txt' & 'subject_train.txt'
trainValues<-read_table("UCI HAR Dataset/train/X_train.txt",col_names=as.character(features$V2))
trainLabels<-read_table("UCI HAR Dataset/train/y_train.txt",col_names="Activity")
trainSubjects<-read_table("UCI HAR Dataset/train/subject_train.txt",col_names="Subject")

# Combining 'testLabels', 'testSubjects' & 'testValues' by columns
testData<-cbind(testLabels,testSubjects,testValues)

# Combining 'trainLabels', 'trainSubjects' & 'trainValues' by columns
trainData<-cbind(trainLabels,trainSubjects,trainValues)

# Combining 'testData' and 'trainData' by rows
data<-rbind(testData,trainData)

# Extracting required column indices using RegEx
index<-grep("[M,m]ean\\(|[S,s]td\\(",names(data))

# Subsetting 'data' based on calculated indices
data<-data[,c(1,2,index)]

# Reading 'activity_labels.txt'
activities<-read_table("UCI HAR Dataset/activity_labels.txt",col_names=FALSE)

# Merging 'data' and 'activities' data sets
data<-merge(data,activities,by.x="Activity",by.y="X1",all.x=TRUE)

# Replacing the first column with newly created 69th column
data[,1]<-data[,69]

# Removing the now redundant 69th column
data<-data[,1:68]

# Grouping 'data' by 'Activity' and 'Subject'
tidyData<-group_by(data,Activity,Subject)

# Summarizing 'tidyData' using 'mean' function
tidyData<-summarize_each(tidyData,funs(mean))

#Converting type of 'Activity' column to factor
tidyData$Activity<-as.factor(tidyData$Activity)

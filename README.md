# Getting and Cleaning Data - Course Project
## The script is divided into five functionalities:
### 1.) Merges the training and the test sets to create one data set & Appropriately labels the data set with descriptive variable names:
First we download the compressed data set
```
temp<-tempfile()
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,temp,mode="wb")
```
Then we read "features.txt"
```
features<-read.table(unzip(temp,"UCI HAR Dataset/features.txt"),sep=" ")
```
Then we read *X_test.txt* (providing column names from the vector *features*), *y_test.txt* and *subject_test.txt*
```
testValues<-read_table(unzip(temp,"UCI HAR Dataset/test/X_test.txt"),col_names=as.character(features$V2))
testLabels<-read_table(unzip(temp,"UCI HAR Dataset/test/y_test.txt"),col_names="Activity")
testSubjects<-read_table(unzip(temp,"UCI HAR Dataset/test/subject_test.txt"),col_names="Subject")
```
Similarly we read *X_train.txt*, *y_train.txt* and *subject_train.txt*
```
trainValues<-read_table(unzip(temp,"UCI HAR Dataset/train/X_train.txt"),col_names=as.character(features$V2))
trainLabels<-read_table(unzip(temp,"UCI HAR Dataset/train/y_train.txt"),col_names="Activity")
trainSubjects<-read_table(unzip(temp,"UCI HAR Dataset/train/subject_train.txt"),col_names="Subject")
```
Then we combine *testLabels*, *testSubjects* & *testValues* by columns respectively.
```
testData<-cbind(testLabels,testSubjects,testValues)
```
Then we combine *trainLabels*, *trainSubjects* & *trainValues* by columns respectively.
```
trainData<-cbind(trainLabels,trainSubjects,trainValues)
```
Then we combine *testData* & *trainData* by rows respectively.
```
data<-rbind(testData,trainData)
```
**The resulting variable *data* contains the single data set which merges the test and train data sets.**
### 2.) Extracts only the measurements on the mean and standard deviation for each measurement:
Using Regular Expressions we extract all column names from variable *data* which contain the strings *"Mean("*, *"mean("*, *"Std("* or *"std("*
```
index<-grep("[M,m]ean\\(|[S,s]td\\(",names(data))
data<-data[,c(1,2,index)]
```
### 3.) Uses descriptive activity names to name the activities in the data set
We read *activity_labels.txt* and then merge *data* and *activities*
```
activities<-read_table(unzip(temp,"UCI HAR Dataset/activity_labels.txt"),col_names=FALSE)
data<-merge(data,activities,by.x="Activity",by.y="X1",all.x=TRUE)
```
Then we replace the first column of *data* with the newly created 69th column
```
data[,1]<-data[,69]
```
Then we remove the redundant 69th column
```
data<-data[,1:68]
```
### 4.) creates a second, independent tidy data set with the average of each variable for each activity and each subject.
We group *data* by columns *Activity* & *Subject*, and then summarize the new table with the *mean* function
```
tidyData<-group_by(data,Activity,Subject)
tidyData<-summarize_each(tidyData,funs(mean))
```
Lastly we convert the type of 'Activity' column to factor
```
tidyData$Activity<-as.factor(tidyData$Activity)
```
**The resulting variable *tidyData* contains the tidy data set which contains the average of each variable for each activity and each subject.**
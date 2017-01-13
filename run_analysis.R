## Manually Dowloaded and extracted the file in my working directory.
# Get the list of the files
data_path <- file.path("C:/Users/jawadah/Documents/UCI HAR Dataset")
files<-list.files(data_path, recursive=TRUE)
files

## Read the files as tables and get files required for the project
dataActivityTest  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)

## Merge train and test data sets 

activity_train_test <- rbind(dataActivityTest, dataActivityTrain)
subject_train_test <- rbind(dataSubjectTest, dataSubjectTrain)
features_train_test <- rbind(dataFeaturesTest, dataFeaturesTrain)

## Set Names to variables 

names(activity_train_test) <- c("activity")
names(subject_train_test) <- c("subject")

## SETTING VARIABLE NAMES FOR FEATURES 

dataFeaturesNames <- read.table(file.path(data_path, "features.txt"),head=FALSE)

names(features_train_test) <- dataFeaturesNames$V2

dataCombine <- cbind(subject_train_test, activity_train_test, features_train_test)

##Extracts only the measurements on the mean and standard deviation for each measurement.

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## Subset the data frame Data by seleted names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

Data <-subset(dataCombine, select=selectedNames)

## Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)

##Appropriately labels the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Creates a second,independent tidy data set and ouput it

library(plyr)

Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

##Prouduce Codebook

library(knitr)




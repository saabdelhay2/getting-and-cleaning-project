## run_analysis.R

## Prepare the stage

## Load required packages
library(dplyr)

## Download and unzip data
datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datasetURL, destfile = "dataset.zip")
downloadDate <- Sys.Date()
downloadDate
unzip("dataset.zip")

## Assign data frames
features_path <- "UCI HAR Dataset/features.txt"
features <- read.table(features_path, 
                       col.names = c("n", "functions"))
activities_path <- "UCI HAR Dataset/activity_labels.txt" 
activities <- read.table(activities_path,
                         col.names = c("code", "activity"))
subject_test_path <- "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(subject_test_path, col.names = "subject")
x_test_path <- "UCI HAR Dataset/test/X_test.txt" 
x_test <- read.table(x_test_path, col.names = features$functions)
y_test_path <- "UCI HAR Dataset/test/y_test.txt"
y_test <- read.table(y_test_path, col.names = "code")
subject_train_path <- "UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(subject_train_path, 
                            col.names = "subject")
x_train_path <- "UCI HAR Dataset/train/X_train.txt"
x_train <- read.table(x_train_path, col.names = features$functions)
y_train_path <- "UCI HAR Dataset/train/y_train.txt"
y_train <- read.table(y_train_path, col.names = "code")

## Merge the training and test sets in one set 
X <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(subject, y, X)

## Extract measurements on the mean and standard deviation
tidy_data <- merged_data %>%
  select(subject, code, contains("mean"), contains("std"))

## Use descriptive activity names for the activities in the data set
tidy_data$code <- activities[tidy_data$code, 2]

## Label the data set with descriptive variable names
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

## Create a second data set with the average of each variable
## for each activity and each subject
final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

## Save final_data as csv file
write.csv(final_data, "Data/final_data.csv")


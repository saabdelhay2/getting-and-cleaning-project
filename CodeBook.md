## Code Book

Script run_analysis.R performs the following tasks:

1- Download and unzip the data set in folder UCI HAR dataset

2- Assign individuals data sets to variables
  features <- features.txt
  activities <- activities_labels.txt
  subject_test <- test/subject_test.txt
  x_test <- test/X_test.txt
  y_test <- test/y_test.txt
  subject_train <- train/subject_train.txt
  x_train <- train/X_train.txt
  y_train <- train/y_train.txt
  
3- Merge data sets
  X <- rbind(x_train, x_test)
  y <- rbind(y_train, x_train)
  subject <- rbind(subject_train, subject_test)
  merged_data <- cbind(subject, y, X)
  
4- Extract mean and standard deviation measurements
  tidy_data <- select(merged_data, subject, code, mean, std)
  
5- Use descriptive names in tidy_data
  Acc --> Accelerator
  Gyro --> Gyroscope
  BodtBody --> Body
  Mag --> magnitude
  t --> Time
  f --> Frequency
  tBody --> TimeBody
  -mean() --> Mean
  -std() --> STD
  freq --> Frequency
  angle --> Angle
  gravity --> Gravity
  
6- Create a second data set from tidy_data
  final_data <- taking the means of each variable for each activity                  and each subject, after groupped by subjec and                       activity.
  Export final_data as final_data.csv in folder Data
  
    
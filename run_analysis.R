## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive activity names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Todo
# 
# label factor activity with descriptive levels
# label columns?
# ---------------
# aggregate: mean of each variable by subject and activity


run_analysis <- function(directory = "uci-har-dataset") {
  setwd(directory)
  
  # read features names
  features <- read.table("features.txt", col.names=c("f.id", "feature"))
  
  ####### TEST data ##########################################
  # read fixed width file X_test
  widths <- rep(16, 561)
  X.test <- read.fwf("test/X_test.txt", widths, col.names=features$feature)
  # add factor to designate these cases as test cases:
  X.test$test.train <- as.factor(rep("test", dim(X.test)[1]))
  
  # read subject data and add it to X.test
  subject.test <- read.table("test/subject_test.txt", col.names="subject")
  X.test$subject <- subject.test$subject

  # read y data and add it to X.test as "activity"
  y.test <- read.table("test/y_test.txt", col.names="activity")
  X.test$activity <- y.test$activity
  
  ####### TRAIN data ##########################################
  
  X.train <- read.fwf("train/X_train.txt", widths, col.names=features$feature)
  X.train$test.train <- as.factor(rep("train", dim(X.train)[1]))
  
  # read subject data and add it to X.test
  subject.train <- read.table("train/subject_train.txt", col.names="subject")
  X.train$subject <- subject.train$subject
  
  # read y data and add it to X.train
  y.train <- read.table("train/y_train.txt", col.names="activity")
  X.train$activity <- y.train$activity
  
  
  # combine X.test and X.train into one data frame
  X <- rbind(X.test, X.train)
  
  # only keep mean and std columns 
  mean.cols <- grep("mean\\.", colnames(X), value=TRUE)
  std.cols  <- grep("std\\.",  colnames(X), value=TRUE)
  keep = c("subject", "test.train", "activity", mean.cols, std.cols)
  X <- X[keep]
  
  # label activity
  labels <- c("walking", "walking.upstairs", "walking.downstairs", "sitting", "standing", "laying")
  activity <- factor( X$activity, levels=c(1:6), labels=labels, ordered=TRUE)
  X$activity <- activity
  X
}
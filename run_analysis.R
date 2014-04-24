# Sets the working directory, loads and cleans the data, and
# calculates the mean of each variable, aggregating over activity and subject.
# Expects a character parameter specifying the directory that contains the data set
#   (default: "uci-har-dataset")
# Returns a list with 2 elements:
#   (1) the tidy data set
#   (2) the mean data, aggregated by activity and subject
#   Also writes both data frames to csv files in specified working directory.
run_analysis <- function(directory = "uci-har-dataset") {
  setwd(directory)
  
  X <- load_and_clean()
  A <- average.by.activity.and.subject(X)
  
  # save to csv
  write.csv(X, "uci-har-tidy.csv")
  write.csv(A, "uci-har-means.csv")
  
  # return both data frames in a list
  list(X, A)
} 



# Loads the data and returns a tidy data frame.
#
# Assumes the following files to be in the working directory:
# * features.txt
# * test/X_test.txt
# * test/subject_test.txt
# * test/y_test.txt
# * train/X_train.txt
# * train/subject_train.txt
# * train/y_train.txt
# Loads and merges test data and train data. Adds 
# * a column to keep track of which case is a training case or a test case, respectively. 
# * a column for the activity, and
# * a column for the subject.
# Then drops all variables that aren't standard deviations or means of measurements. 
# Then labels the activity codes and turns the activity column into a factor.
#
# Returns a data frame with columns activity, subject, test.train, and the means and
# standard deviations of the measurements.
load_and_clean <- function(){
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
  
  # beautify column names by replacing ... and .. with a single .
  names(X) <- sub("\\.\\.\\.", ".", names(X))
  names(X) <- sub("\\.\\.", ".", names(X))
  
  # label activity
  labels <- c("walking", "walking.upstairs", "walking.downstairs", "sitting", "standing", "laying")
  activity <- factor( X$activity, levels=c(1:6), labels=labels, ordered=TRUE)
  X$activity <- activity
  X
}


# Groups the data frame X by activity and subject, calculating the mean for the 
# measurement columns.
# The column "test.train" is dropped (if it exists).
# Expects a data frame with columns "activity" and "subject". 
# Returns a data frame that contains the mean of each measurement grouped 
# (and ordered) by activity and subject.
average.by.activity.and.subject <- function(X) {
  
  # aggregate by subject and activity, but throw test and train cases together;
  # so remove column "test.train":
  tmp.df <- X[ colnames(X) != "test.train"]
  
  A <- aggregate(. ~ tmp.df$activity + tmp.df$subject, data=tmp.df, FUN=mean)
  A <- A[,c(1:2, 5:dim(A)[2])]    # get rid of superfluous columns 3 and 4
  names(A) <- sub("^tmp.df\\$", "", names(A))  # rename columns  
  A[ order(A$activity, A$subject), ]  # sort by activity, then subject
}

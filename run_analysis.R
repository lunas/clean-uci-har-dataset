# Todo
# 
# label factor activity with descriptive levels
# label columns?
# ---------------
# aggregate: mean of each variable by subject and activity
#
# Documentation in Readme/Code: 
# "make a choice and document reason ("mean", "std")
#     ("Extracts only the measurements on the mean and standard deviation for each measurement.")
# document assumptions about input data (zip file, online, where it is etc):
#     "2) We assume that files have been downloard and extracted to a local directory."

run_analysis <- function(directory = "uci-har-dataset") {
  setwd(directory)
  
  X <- load_and_clean()
  A <- aggregate.subject.activity(X)
  list(X, A)
} 

# load and clean data

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
  
  # label activity
  labels <- c("walking", "walking.upstairs", "walking.downstairs", "sitting", "standing", "laying")
  activity <- factor( X$activity, levels=c(1:6), labels=labels, ordered=TRUE)
  X$activity <- activity
  X
}

aggregate.subject.activity <- function(X) {
  
  # aggregate by subject and activity, but throw test and train cases together;
  # so we need to remove the column test.train:
  tmp.df <- X[ colnames(X) != "test.train"]
  
  A <- aggregate(. ~ tmp.df$activity + tmp.df$subject, data=tmp.df, FUN=mean)
  A <- A[,c(1:2, 5:dim(A)[2])]    # get rid of superfluous columns 3 and 4
  names(A) <- sub("^tmp.df\\$", "", names(A))  # rename columns  
  A[ order(A$activity, A$subject), ]  # sort by activity, then subject
}

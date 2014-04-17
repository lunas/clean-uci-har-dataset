## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive activity names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Todo
#
# merge test/X_test.txt and train/X_train.txt into X.txt (rbind), with factor test.train
#   these files are fixed width, each column=16 chars
# merge test/y_test.txt and train/y_train.txt into y.txt (rbind), with factor test.train
#   these files are fixed width, each column=16 chars
# merge test/subject_test.txt and train/subject_train.txt into subject.txt, with factor test.train
# merge X.txt and y.txt into Xy.txt (cbind)
# merge Xy.txt and subject.txt into Xysub.txt. Should result in (7352+2947) x (561 + 1 + 1) table
# 
# Drop all columns except y (activity), subject, and the mean and std columns


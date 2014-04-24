# Code book for the UCI-HAR data set

## Background

This project cleans the Human Activity Recognition Using Smartphones Data Set downloadable here:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The experiment and processing of the raw data is described there and within the README.txt file included
in the zip file containing the data set:
[UCI HAR Dataset.zip](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip)

## Processing

Specifically, this project does the following processing:

* Merges the measurement data of both the test and train data set.
  To keep track of which case is a test case and which case is a training case,
  a new variable "test.train" is introduced with levels "train" and "test".
* Adds the variable ```subject``` (from subject_test.txt and subject_train.txt, respectively)
* Adds the variable ```activity```  (from y_test.txt and y_train.txt, respectively)
* drops all variables that aren't mean or standard deviations (see section Code book, below)
* makes the variable ```activity``` a factor and labels its levels.
* saves the resulting data frame into a comma separated file called "uci-har-tidy.txt"

Based on this cleaned data set X, a second data frame A is created, that

* drops the variable ```test.train```
* calculates the average of each variable for each activity and each subject.
  I.e. A aggregates over ```activity``` and ```subject``` by taking the mean
  of the remaining variables

## Code book

The tidy csv-file "uci-har-tidy.txt" contains 10299 rows and 69 variables:

* ```subject``` the id of the subject, as originally specified in the files subject_test.txt and subject_train.txt, respectively
* ```activity``` a factor describing what the subject was doing at the time of the measurement.
  * It has 6 levels: walking < walking.upstairs < walking.downstairs < sitting < standing < laying
* ```test.train``` a factor describing whether this row is a test case or a training case.
  * It has 2 levels: test and train.
* the remaining 66 variables are means and standard deviations as described in the README.txt file included
  in the zip file containing the [UCI-HAR dataset](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip).  
  All these variables are normalized and bounded within [-1,1].

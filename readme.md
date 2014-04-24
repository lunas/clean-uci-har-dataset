Loading and cleaning the UCI-HAR data set
=========================================

The script run_analysis.R processes the UCI-HAR dataset as described in the file [codebook.md](codebook.md).

To run the script:

* change to the directory that contains the script (using ```setwd("my_folder")```)
* load the script: ```source("run_analysis.R")```
* call the function "run_analysis"; it expects the name of the directory containing the UCI-HAR dataset.  
  Default is "uci-har-dataset".   
  Assuming the current directory contains the UCI-HAR dataset in a directory called uci-har-dataset, do:  
  ```result <- run_analysis()```   
  and wait.
* The function returns a list with 2 elements:
  1. ```result[[1]]```: a data frame X containing the tidy data set as described in the [codebook.md](docebook.md)
  2. ```result[[2]]```: a data frame A with the means of all measurements for each subject and activity.  
* the function also creates to csv-files in the directory containing the UCI-HAR dataset:
  1. a csv-file called "uci-har-tidy.txt" containing data frame X
  2. a csv-file called "uci-har-means.csv" containging data frame A

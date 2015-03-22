# README.md
Saturday, March 21, 2015  

## Introduction

This assignment uses data from the <a href="http://archive.ics.uci.edu/ml/">UC Irvine Machine Learning Repository</a>, a popular repository for machine learning
datasets.  Details on the original data collection, data for the course project, and variables created as part of the project can be found in **CodeBook.md**. 

The data files and documentation can be downloaded from the Coursera Getting and Cleaning Data course web site  

* **Data**: <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">HAR Data and Documentation zip file</a> [62.6Mb]

## Loading the data

Prior to loading the data, <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">the files from the course website</a> need to be downloaded and unzipped.
The R script **run_analysis.R** will load and clean the data assuming the raw files are in the R working directory. 

The script uses the following datasets:

1.  **features.txt**:  561 x 2 matrix of variable id numbers (1 to 561) and variable names.  The variable names in this file are not compliant with R variable naming conventions, e.g., tBodyAcc-mean()-X, tBodyAcc-mean()-Y, and tBodyAcc-mean()-Z.  The R script **run_analysis.R** will clean up the variable names to make them R friendly.
2.  **activity_labels.txt**:  6 x 2 matrix of activity id numbers (1 to 6) and activity names (see above).
3.  **X_train.txt** and **X_test.txt**:  7352 x 561 matrix and 2947 x 561 matrix with the raw data.  A complete description of the raw data is given below.  The train and text datasets are 70% and 30% samples from the parent dataset.  These datasets are concatenated by the **run_analysis.R** script.
4.  **y_train.txt** and **y_test.txt**:  7352 x 1 matrix and 2947 x 1 matrix with the activity number for each observation in the raw datasets.  Values for the activities range from 1 to 6.
5.  **subject_train.txt** and **subject_test.txt**:  7352 x 1 matrix and 2947 x 1 matrix with the subject id number, a value from 1 to 30, for each observation in the raw data.

## Creating the tidy dataset

### Steps to create the tidy dataset

1.  Download the project datasets (zip file)  <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">HAR Data and Documentation zip file</a> [62.6Mb]
2.  Unzip all files into the R working directory
3.  Source the file **run_analysis.R** (i.e., enter `source("run_analysis.R")` at the R command line)

Additional detail available at:  https://github.com/dixon9/GETTING_AND_CLEANING_DATA/blob/master/CodeBook.md

## Description of the R script "run_analysis.R"
The script merges (concatenates) the training and the test sets to create one data set, extracts only the measurements on the mean and standard deviation for each primary measurement (signal), uses descriptive activity names to name the activities in the data set, appropriately labels the data set with descriptive variable names, and creates a second, independent tidy data set with the average of each variable for each activity and each subject.  The variables that are averaged for this tidy dataset include any mean, standard deviation, and mean frequency estimates derived from the raw measurements (signals); these variables are designated in the **features.txt** dataset by the variable name suffixes: mean(), std(), and meanFreq().  For example, for the raw measurements tBodyAcc-XYZ, the raw variable names from **features.txt** are:  tBodyAcc-mean()-X, tBodyAcc-mean()-Y, and tBodyAcc-mean()-Z.  The script will change the raw variable names to the R-friendly names:  tBodyAcc.mean.X, tBodyAcc.mean.Y, and tBody.mean.Z.  For each subject and activity, there are multiple mean measurements.  To continue the example, for subject #1 and the activity "LAYING", there are 95 measurements of t.BodyAcc.mean.X, tBodyAcc.mean.Y, and tBodyAcc.mean.Z.  The script will generate new variables for the average of the 95 measurements:  avg.t.BodyAcc.mean.X, avg.t.BodyAcc.mean.Y, and avg.t.BodyAcc.mean.Z.      

##  Return dataset
After the R script **run\_analysis.R** is run, the output dataset is **tidy\_data.txt**.  This dataset includes 1 column with the subject ID numbers (subjectID), 1 column with the activity names (activity.label) and 79 columns with the average values of the mean and standard deviation measurements for each raw measurement (signal).  The tidy dataset includes the average values of the mean and standard deviation measurements for each subject and activity.  The name of the variable for the average value appends a prefix "avg.*" to the measurement name:  avg.tBodyAcc.mean.X, avg.tBodyAcc.mean.Y, and avg.tBodyAcc.mean.Z.     

## Acknowledgements
This course project took suggestions and borrowed code snippets from the Coursera Discussion Forum for Getting and Cleaning Data, in particular <a href="http://archive.ics.uci.edu/ml/">UC Irvine Machine
Learning Repository</a>.  The variable names and documentation were based on dataset documentation from the HAR website and the Coursera course website.

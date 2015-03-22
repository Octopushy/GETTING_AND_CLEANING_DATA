#=============================================================================#
##  Title:  run_analysis.R
##  COURSERA Getting and Cleaning Data
##  Course project
##  Description:
##  You should create one R script called run_analysis.R that does the following. 
##  Merges the training and the test sets to create one data set.
##  Extracts only the measurements on the mean and standard deviation for each measurement. 
##  Uses descriptive activity names to name the activities in the data set
##  Appropriately labels the data set with descriptive variable names. 
##  From the data set in previous step, creates a second, independent tidy data set 
##  with the average of each variable for each activity and each subject.
##  Output:
##  "tidy_data.txt" a "tidy" dataset of averages of the mean and standard deviation
##  for each of the raw measurements (features) with subjct id numbers and 
##  activity names.
##  Note:  
##  Decisions that require judgment calls follow discussion
##  https://class.coursera.org/getdata-012/forum/thread?thread_id=9
##  See README.md in the GitHub repo for a complete description of the 
##  data used in this script.
#=============================================================================#

##  Code for course project for Getting and Cleaning Data
#  Library statements
library(xlsx)
library(XML)
library(data.table)
library(xtable)
library(dplyr)
library(reshape2)

## Step 1:  Merge the training and test datasets to create one dataset
# Note:  this step requires concatenation, not merging
# Raw data should be in the working directory

# Read in the variable names--561 in total
features        <- read.table("features.txt")
# Read in the activity labels--6 in total
activity.labels <- read.table("activity_labels.txt", 
                              col.names = c("activity", "activity.label"))

# Read in the train and test raw data
X.train <- read.table("X_train.txt", col.names = features[, 2])
X.test  <- read.table("X_test.txt",  col.names = features[, 2])
# Read in the activity numbers
y.train <- read.table("y_train.txt", col.names = "activity")
y.test  <- read.table("y_test.txt",  col.names = "activity")
# Read in the subject id numbers for each row of the raw data
subject.train <- read.table("subject_train.txt", col.names = "subjectID")
subject.test  <- read.table("subject_test.txt",  col.names = "subjectID")

# Create two data frames, one for the training data and
# one for the testing data.
# Each data frame will have the subject id numbers,
# the activity names, and the data.
test1 <- tbl_df(cbind(subject.train, y.train, X.train))
test2 <- tbl_df(cbind(subject.test, y.test, X.test))

# Create a single dataset by concatenating test1 and test2
test3 <- rbind(test1, test2)

# Need to add the activity labels in lieu of activity numbers

## Step 2:  Extract only the measurements on the mean and standard deviation for each measurement
# Use "fixed = TRUE" to do exact matching
# Note that R will delete the "()" from the feature names and replace with a "."
# "value = FALSE" will ensure the index is returned...this is the default
# If I search for "mean" vs. "mean.", I will get meanFreq or not
cols.keep.mean1 <- grep("mean", names(test3), value = FALSE, fixed = TRUE)
cols.keep.mean2 <- grep("mean.", names(test3), value = FALSE, fixed = TRUE)
cols.keep.std <- grep("std", names(test3), value = FALSE, fixed = TRUE)
cols.keep <- c(1, 2, cols.keep.mean1, cols.keep.std)

test3.keep <- test3[, cols.keep]
# R has already changed the variable names from those in "features.txt".
# The next step is to make them more R-friendly by removing extra "..".
names.test3.keep <- names(test3.keep)
clean.names <- sub("..", "", names.test3.keep, fixed = TRUE)
names(test3.keep) <- clean.names

# Use chained expressions from plyr to get the dataframe with the means
# Group by subjectID and activity.
# Summarise to compute the mean of each group for each variable.
# Ungroup to performn the subsequent data processing.
mean.dataframe <- 
        test3.keep %>%
        group_by(subjectID, activity) %>%
        summarise_each(funs(mean)) %>%
        ungroup()

## Step 3:  Use descriptive activity names to name the activities in the dataset
mean.dataframe.activitylabel <- left_join(mean.dataframe, activity.labels, by="activity")

# Reorder the columns to put the activity labels in the third column
mean.dataframe.tidy <- tbl_df(cbind(select(mean.dataframe.activitylabel, subjectID), 
                             select(mean.dataframe.activitylabel, activity.label),
                             select(mean.dataframe.activitylabel, -subjectID, -activity, -activity.label)))

## Step 4:  Appropriately label the dataset with descriptive variable names
# To keep it simple, the new variable names will just have a prefix of "avg.*"
rename.data <- mean.dataframe.tidy[, -c(1,2)]
new.names <- paste("avg.", names(mean.dataframe.tidy[, -c(1, 2)]), sep = "")
names(rename.data) <- new.names
tidy_data <- cbind(mean.dataframe.tidy[, c(1,2)], rename.data)
save(tidy_data, file = "tidy_data.RData")
## Step 5:  From the dataset in step 4, create a second, independent tidy dataset 
##  with the average of each variable for each activity and each subject
# tidy.data is the tidy dataset, but in Step 5 it needs to be output.
write.table(tidy.data, file = "tidy_data.txt", row.names = FALSE)


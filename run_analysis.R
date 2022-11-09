# Coursera - Data Science by John Hopkins University
# Getting and Cleaning Data - Course Project 
# Author: David Sebastian Arcos Del Salto


# INSTRUCTIONS -------------------------------------------------------------

# The purpose of this project is to demonstrate your ability to collect, work with, 
# and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 

# You will be required to submit: 
## 1) a tidy data set as described below, 
## 2) a link to a Github repository with your script for performing the analysis, 
## 3) a code book that describes the variables, the data, and any transformations or work 
##      that you performed to clean up the data called CodeBook.md. 
## 4) a README.md in the repo with your scripts. This repo explains how all of the scripts work and 
##      how they are connected.

# You should create one R script called run_analysis.R that does the following. 
  
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject.

# Here are the data for the project:
  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  


# 1. LOAD PACKAGES AND GET THE DATA ------------------------------------------

packages <- c("data.table", "reshape2", "tidyverse")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
library(data.table)
library(reshape2)
library(tidyverse)

if(!file.exists("./GetCleanProject")){dir.create("./GetCleanProject")}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile = "./GetCleanProject/datafiles.zip", method = "curl")

unzip(zipfile = "./GetCleanProject/datafiles.zip", exdir = "./GetCleanProject")


# 2. LOADING THE DATA -----------------------------------------------------

# Change working directory
getwd()
directorio <- paste(getwd(),"GetCleanProject/UCI HAR Dataset", sep = "/")
directorio
setwd(directorio)
list.files()

# a. Features
features <- read.table("features.txt", col.names = c("N","Features"))

# b. Activities
activities <- read.table("activity_labels.txt", col.names = c("ID", "Activity"))

# c. Train data
subject_train <- read.table("train/subject_train.txt", col.names = "Volunteer")
y_train <- read.table("train/y_train.txt", col.names = "ActivityCode")
x_train <- read.table("train/X_train.txt", col.names = features$Features)

# d. Test data
subject_test <- read.table("test/subject_test.txt", col.names = "Volunteer")
y_test <- read.table("test/y_test.txt", col.names = "ActivityCode")
x_test <- read.table("test/X_test.txt", col.names = features$Features)


# 3. MERGE TRAIN AND TEST DATASETS INTO ONE DATASET -----------------------

Xset <- rbind(x_train, x_test)
Yset <- rbind(y_train, y_test)
Volunteer <- rbind(subject_train, subject_test)
df <- cbind(Volunteer, Yset, Xset)
colnames(df)

# 4. EXTRACT THE MEAN AND STANDARD DEVIATION MEASUREMENTS -----------------

columns_needed <- (grep("(mean|std)\\(\\)", features$Features)+2)

final_df <- df[, c(1,2,columns_needed)]

colnames(final_df)
str(final_df)

# 5. SET THE APPROPIATE LABELS --------------------------------------------

# Set the labels for the activity code
final_df$ActivityCode <- activities[final_df$ActivityCode, 2]

# Set the column names - Features names
colnames(final_df)
names(final_df)[2] = "Activity"
names(final_df)<-gsub("Acc", "Accelerometer", names(final_df))
names(final_df)<-gsub("Gyro", "Gyroscope", names(final_df))
names(final_df)<-gsub("BodyBody", "Body", names(final_df))
names(final_df)<-gsub("Mag", "Magnitude", names(final_df))
names(final_df)<-gsub("^t", "Time", names(final_df))
names(final_df)<-gsub("^f", "Frequency", names(final_df))
names(final_df)<-gsub("tBody", "TimeBody", names(final_df))
names(final_df)<-gsub("-mean()", "Mean", names(final_df), ignore.case = TRUE)
names(final_df)<-gsub("-std()", "STD", names(final_df), ignore.case = TRUE)
names(final_df)<-gsub("-freq()", "Frequency", names(final_df), ignore.case = TRUE)
names(final_df)<-gsub("angle", "Angle", names(final_df))
names(final_df)<-gsub("gravity", "Gravity", names(final_df))



# 6. CREATE AN INDEPENDENT TIDY DATA SET ----------------------------------

agg_df <- aggregate(. ~Volunteer + Activity, final_df, mean)

tidy_df <- gather(agg_df, Feature, Mean_value, -c(Volunteer, Activity)) %>% 
  arrange(Volunteer, Activity) 

data.table::fwrite(x = tidy_df, file = "FinalTidyData.txt", quote = FALSE)
write.table(tidy_df, file = "finaltidydata.txt",row.name=FALSE)
render("codebook.Rmd")


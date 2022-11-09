# Getting_cleaning_data
This repository is a submission for the Getting and Cleaning Data Course Project by John Hopkins University. It has the instructions on how to run analysis required as parte of the final project, related to a Human Activity recognition dataset.

Dataset
Human Activity Recognition Using Smartphones, obtained from:  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Files
CodeBook.Rmd: a code book that describes the variables, the data, and any transformations or work that I performed to clean up the data, written in Rmarkdown

run_analysis.R: a script for getting the data and uploading it to R, extracting the mean and standard deviation measurements, and for converting the data set into a tidy data set that contains the calculated mean for every variable, as described in the course project’s instructions:

 * Merges the training and the test sets to create one data set.
 * Extracts only the measurements on the mean and standard deviation for each measurement.
 * Uses descriptive activity names to name the activities in the data set
 * Appropriately labels the data set with descriptive variable names.
 * Create a tidy data set with the mean of each variable for each activity and each subject.

finaltidydata.txt: is the exported final data after going through all the sequences described above.


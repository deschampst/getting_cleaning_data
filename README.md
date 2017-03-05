# Getting and Cleaning Data - Final Assignment

The run_analysis.R script downloads data from the internet, loads it into R, and converts it into a tidy dataframe containing the means of the variables of interest, following these steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the means and standard deviations for each measurement.
3. Uses descriptive activity names for the activities in the data set.
4. Appropriately labels the columns with descriptive names.
5. Creates a second, independent tidy data set with the means for each activity and each subject.

To run this script in RStudio:
* download run_analysis.R into your working directory
* type source("run_analysis.R") in the RStudio console

Please note: This script produces two files:
* cleandata.txt -- contains tidy data set with observed variables
* cleanmeans.txt -- contains tidy data set with means on each variable for each activity and each subject





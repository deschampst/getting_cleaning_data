################################################################################
# COURSERA - DATA SCIENCE SPECIALIZATION
# COURSE 3 - GETTING AND CLEANING DATA
# FINAL ASSIGNMENT
# AUTHOR: Tiffany Deschamps
# DUE: 2017-03-05
################################################################################

# load the required packages
library(dplyr)
library(reshape2)

# download and unzip the data
if (!file.exists("./data")) {
      dir.create("./data")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "./data/data.zip", method = "curl")

unzip("./data/data.zip", exdir = "./data")

list.files("./data")
## [1] "data.zip"        "UCI HAR Dataset"


################################################################################
# STEP 1: Merges the training and the test sets to create one data set.
################################################################################

# load the training data
trainsubj <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
trainactivity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainmeasures <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

# load the test data
testsubj <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
testact <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testmeasures <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

# load features
features <- read.table("./data/UCI HAR Dataset/features.txt")

# use rbind() to append test data to training data
subj <- rbind(trainsubj, testsubj)
activity <- rbind(trainactivity, testact)
measures <- rbind(trainmeasures, testmeasures)

# assign names to subj, activity, and measures
names(subj) <- "subject"
names(activity) <- "activity"
names(measures) <- features$V2

# use cbind() to create full dataset
data <- cbind(subj, activity, measures)


################################################################################
# STEP 2: Extracts only the measurements on the mean and standard deviation for
#         each measurement.
################################################################################

# keep only columns that are means or standard deviations of measures
goodnames <- grepl("(subject|activity|mean\\(|std)", names(data)) # find good columns
data <- data[, goodnames] # subset data


################################################################################
# STEP 3: Uses descriptive activity names to name the activities in the data.
################################################################################

# make data$activity a factor variable with descriptive names
data$activity <- factor(data$activity)
levels(data$activity) <- c("walking", "walking_upstairs", "walking_downstairs",
                           "sitting", "standing", "lying")


################################################################################
# STEP 4: Appropriately labels the data set with descriptive variable names.
################################################################################

# rename the column names
oldnames <- names(data)
newnames <- gsub("^t", "Time", oldnames)
newnames <- gsub("\\-mean\\(\\)(\\-)?", "Mean", newnames)
newnames <- gsub("\\-std\\(\\)(\\-)?", "StDev", newnames)
newnames <- gsub("Mag", "Magnitude", newnames)
newnames <- gsub("f", "FFT", newnames)

names(data) <- newnames # assigns the new names to the data frame

# write the data to a text file
write.table(data, "cleandata.txt", col.names = TRUE, row.names = FALSE)


################################################################################
# STEP 5: From the data in step 4, creates a second, independent tidy data set
#         with the average of each variable for each activity and each subject.
################################################################################

# melt the data to calculate the means
meltedData <- melt(data, id.vars = c("subject", "activity"))

# calculate means of each variable for each subject
means <- dcast(meltedData, subject + activity ~ variable, mean)

# write out the means
write.table(means, "cleanmeans.txt", col.names = TRUE, row.names = FALSE)

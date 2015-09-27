## You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
library(reshape2)

fileName <- "getdata_dataset.zip"

## If file exists, do not re-download
if (!file.exists(fileName)) {
  message("file archive does not exist, downloading...")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, fileName, method="curl")
} else {
  message("file archive exists")
}

# If file is already unzipped, do not re-unzip
if (!file.exists("UCI HAR Dataset")) {
  message("file not extracted, extracting...")
  unzip(fileName)
} else {
  message("file archive extracted")
}

message("loading activity labels")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

message("loading data column names")
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

message("extracting mean and standard deviation measurements")
extractedFeatures <- grepl("mean|std", features)

message("loading test data")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(xTest) = features

message('extracting only mean and standard deviation for each measurement')
xTest <- xTest[,extractedFeatures]

yTest[,2] = activityLabels[yTest[,1]]
names(yTest) = c("Activity_ID", "Activity_Label")
names(subjectTest) = "Subject"

message("binding test data")
testData <- cbind(as.data.table(subjectTest), yTest, xTest) 


message("loading training data")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

names(xTrain) = features
xTrain = xTrain[,extractedFeatures]

yTrain[,2] = activityLabels[yTrain[,1]]
names(yTrain) = c("Activity_ID", "Activity_Label")
names(subjectTrain) = "Subject"

message("binding test data")
trainData <- cbind(as.data.table(subjectTrain), yTrain, xTrain)

message("combining datasets")
data <- rbind(testData, trainData)

message("melt data")
labels <- c("Subject", "Activity_ID", "Activity_Label")
dataLabels <- setdiff(colnames(data), labels)
meltData = melt(data, id = labels, measure.vars = dataLabels)

message("apply mean function to dataset")
cleanData <- dcast(meltData, Subject + Activity_Label ~ variable, mean)

message("writing file")
write.table(cleanData, file = "./cleanData.txt", row.names = FALSE, quote = FALSE)



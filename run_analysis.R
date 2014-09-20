

## STEP 1 ###################

X <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y <- read.table("UCI HAR Dataset\\train\\y_train.txt")
subject <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

trainData <- cbind(X, y, subject)

## STEP 2 ###################

X <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y <- read.table("UCI HAR Dataset\\test\\y_test.txt")
subject <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

testData <- cbind(X, y, subject)

## STEP 3 ###################

allData <- rbind(trainData, testData)

features <- read.table("UCI HAR Dataset\\features.txt", stringsAsFactors = FALSE)
names(allData) <- c(features[, 2], "activity", "subject")

## STEP 4 ###################

activities <- read.table("UCI HAR Dataset\\activity_labels.txt", stringsAsFactors = FALSE)
activity_ids <- allData$activity

for (i in seq_along(activity_ids)) {

	allData$activity[i] <- activities[activity_ids[i], 2]
}

## STEP 5 ###################

cols <- sort(c(grep("mean", names(allData)), grep("std", names(allData))))
cols <- c(cols, ncol(allData) - 1, ncol(allData))

allData <- allData[, cols]

## STEP 6 ###################

library(dplyr)
allData <- allData %>% group_by(activity, subject) %>% summarise_each(funs(mean))

write.table(allData, file = "summarized_data.txt", row.names = FALSE)
View(allData)

## STEP 7 ###################

rem <- c(ls(), "rem")
rm(list = rem[rem != "allData"])


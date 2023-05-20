# Create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.


# we will be using data.table library as it is efficient in handling
# large data as tables.

library(data.table)
library(dplyr)

# The supporting metadata of this data are the features and
# the name of the activities. These metadata is loaded into the
# following variables
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Training and Testing data are split up into
# 1. Subjects
# 2. activity, and
# 3. features
# and are present in corresponding files. These files are loaded in following variables

subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)


# Loading Testing data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)


# Step-1 Merging of Training and Testing data as one large data set
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

# The columns names are named from the metadata read previously as featuresNames
colnames(features) <- t(featureNames[2])

# Similary other columns are named
# and the data is merged to create one large data set
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

# Part 2 - Extracts only the measurements on the mean and 
# standard deviation for each measurement
# Any empty column is ignored
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

# Activity and Subject column is also appended with mean
# and standard deviation column
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)

# We create extractedData with the selected columns in requiredColumns. 
# And again, we look at the dimension of requiredColumns.
extractedData <- completeData[,requiredColumns]
dim(extractedData)

# Part 3 - Uses descriptive activity names to name the activities 
# in the data set

# The activity field in extractedData is originally of numeric type.
# We need to change its type to character so that it can accept activity names. 
# The activity names are taken from metadata activityLabels.
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6)
{
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

# We need to factor the activity variable, 
# once the activity names are updated.
extractedData$Activity <- as.factor(extractedData$Activity)

# Part 4 - Appropriately labels the data set with descriptive 
# variable names
names(extractedData)

# By examining extractedData, we can say that the following 
# acronyms can be replaced:
  
# Acc can be replaced with Accelerometer
# Gyro can be replaced with Gyroscope
# BodyBody can be replaced with Body
# Mag can be replaced with Magnitude
# Character f can be replaced with Frequency
# Character t can be replaced with Time

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

# Again display the names of the columns
names(extractedData)

# Part 5 - From the data set in step 4, 
# creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

# We create tidyData as a data set with average for each activity 
# and subject. 
# Then, we order the enties in tidyData and write it into data file 
# Tidy.txt that contains the processed data.
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)






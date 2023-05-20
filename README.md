# CourseProjectWeek4
The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

1. Download and Unzip the dataset
    Dataset downloaded and extracted under the folder called UCI HAR Dataset

2. Assign each data to variables
  
  featureNames <- features.txt : 561 rows, 2 columns
    The features selected for this database come from the accelerometer and          gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

  activitityLabels <- activity_labels.txt : 6 rows, 2 columns
    List of activities performed when the corresponding measurements were taken      and its codes (labels)

subjectTrain <- test/subject_train.txt : 7352 rows, 1 column
  contains train data of 21/30 volunteer subjects being observed

featuresTrain <- test/X_train.txt : 7352 rows, 561 columns
  contains recorded features train data

activityTrain <- test/y_train.txt : 7352 rows, 1 columns
  contains train data of activities’code labels

subjectTest <- test/subject_test.txt : 2947 rows, 1 column
  contains test data of 9/30 volunteer test subjects being observed

featuresTest <- test/X_test.txt : 2947 rows, 561 columns
  contains recorded features test data

activityTest <- test/y_test.txt : 2947 rows, 1 columns
  contains test data of activities’code labels

Merges the training and the test sets to create one data set
features(10299 rows, 561 columns) is created by merging 
featuresTrain and featuresTest using rbind() function

acitivty (10299 rows, 1 column) is created by merging 
activityTrain and activityTest using rbind() function

Subject (10299 rows, 1 column) is created by merging 
subjectTrain and subjectTest using rbind() function

completeData (10299 rows, 563 column) is created by merging subject, 
activity and features using cbind() function

columnsWithMeanSTD contains indices that have either mean and STD in them

requirecolumns 
  is a list containing columnsindices of mean and STD along with
  acitivity and subjects column

extractedData
  contains only the measurements on the mean and standard deviation for each       measurement
  
The activity field in extractedData is originally of numeric type. We need to change its type to character so that it can accept activity names. The activity names are taken from metadata activityLabels.

Then we factored the activity variable

Uses descriptive activity names to name the activities in the data set
Entire numbers in code column of the extractedData replaced with corresponding activity taken from second column of the activities variable

Appropriately labels the data set with descriptive variable names

By examining extractedData, we can say that the following acronyms can be replaced:
Acc can be replaced with Accelerometer
Gyro can be replaced with Gyroscope
BodyBody can be replaced with Body
Mag can be replaced with Magnitude
Character f can be replaced with Frequency
Character t can be replaced with Time

we then set Subject also as a factor variable.

and Finally from the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData (180 rows, 88 columns) is created by sumarizing extractedData taking the means of each variable for each activity and each subject, after groupped by subject and activity.

Write tidyData as Tidy.txt in the current working directory.
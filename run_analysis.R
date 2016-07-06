## 1.Downloading and unzipping dataset

## this data was manually downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## transferred to my working directory and unzipped manually
## all necessary files now in my desktop/ working directory so i can them directly with read.table.

## 2. Merging the training and the test sets to create one data set:
        
# Reading trainings tables:
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

# Reading testing tables:
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# Reading feature vector:
features <- read.table("features.txt")

# Reading activity labels:
activityLabels = read.table("activity_labels.txt")

## Assigning column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

## Merging the data as a set:
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_train, merge_test)

## 3.Extracting only the measurements on the mean and standard deviation for each    measurement

##Reading column names:
colNames <- colnames(setAllInOne)

##Created vector for defining ID, mean and standard deviation:

mean_and_std <- (grepl("activityId" , colNames) | 
                         grepl("subjectId" , colNames) | 
                         grepl("mean.." , colNames) | 
                         grepl("std.." , colNames) 
)      

## Making nessesary subset from setAllInOne:
        set_mean_std <- setAllInOne[ , mean_and_std == TRUE]
## 4. Using descriptive activity names to name the activities in the data set:
        setWithActivityNames <- merge(set_mean_std, activityLabels,
                                      by='activityId',
                                      all.x=TRUE)       
##Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
        
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)





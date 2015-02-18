# absolute path to directory with Samsung Data
path <- ".../UCI HAR Dataset"

# reading test and train data to data frames
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ), header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt" ), header = FALSE)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ), header = FALSE)
activityTrain  <- read.table(file.path(path, "train" , "Y_train.txt" ), header = FALSE)
subjectTrain  <- read.table(file.path(path, "train" , "subject_train.txt" ), header = FALSE)
featuresTrain  <- read.table(file.path(path, "train" , "X_train.txt" ), header = FALSE)

# discovering data dimension and structure
dim(activityTrain)
dim(subjectTrain)
dim(featuresTrain)
dim(activityTest)
dim(subjectTest)
dim(featuresTest)
str(activityTest)
str(activityTrain)
str(subjectTest)
str(subjectTrain)
head(featuresTest)[1:6]
head(featuresTrain)[1:6]

# merging test and trainig data
activity<- rbind(activityTrain, activityTest)
subject <- rbind(subjectTrain, subjectTest)
features<- rbind(featuresTrain, featuresTest)

# control data dimension and structure for merged data
dim(activity)
dim(subject)
dim(features)
str(activity)
str(subject)
head(features)[1:6]

# renaming variables in subject and activity data frames
names(subject)<-"subject"
names(activity)<-"activity"

# control renaming
str(activity)
str(subject)

# obtaining features names from file
featuresNames <- read.table(file.path(path, "features.txt"), head=FALSE)


# discovering data dimension and structure
dim(featuresNames)
head(featuresNames)

# renaming variables in features data frames
names(features)<- featuresNames$V2

# filtering all mean and std features
temp <- featuresNames[grep("(mean|std)\\(", featuresNames$V2),]
head(temp)
tail(temp)
features_mean_and_std <- features[,temp[,1]]
str(features_mean_and_std)

# merging filtered data with subject and activity in one data frame
data <- cbind(subject, activity, features_mean_and_std)
head(data)[1:6]

# obtaining activity_labels from file
activity_labels  <- read.table(file.path(path, "activity_labels.txt" ), header = FALSE)
activity_labels

# replacing code of activity by name
for (i in 1:6) {  
        data$activity[data$activity == as.character(i)] <- as.character(activity_labels$V2[i])}

# control of replacing
head(data)[1:6]
data[567:568, 1:6]
tail(data)[1:6]

# labeling the data set with descriptive variable names
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))

# control of labeling
str(data)

# creating tidy data set with the average of each variable for each activity and each subject
tidyData <- aggregate(.~subject + activity, data, mean)

# control of correct aggregating
length(unique(data$subject))*length(unique(data$activity)) == dim(tidyData)[1]

# writing to file
write.table(tidyData, file = "tidydata.txt", row.name=FALSE)







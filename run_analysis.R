# Downloading the file

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url, destfile = "E:/Pera/Coursera/Course Project/Course-Project/UCI Har Dataset.zip", method = "curl")


# Unzipping the zip fle

unzip("E:/Pera/Coursera/Course Project/Course-Project/UCI Har Dataset.zip")

#Reading the files

features <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_test <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
x_train <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

y_test <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/test/y_test.txt", col.names = "codes")
y_train <- read.table("E:/Pera/Coursera/Course Project/Course-Project/UCI HAR Dataset/train/y_train.txt", col.names = "codes")


# Merging the data

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

merged_data <- cbind(Subject, Y, X)

# Extracting mean and standard deviation

library(dplyr)
extracted_data <- merged_data %>% select(subject,codes, contains("mean"), contains("std"))


# Naming the activities using descriptive activity names

merged_data$codes <- activities[merged_data$codes, 2]


# Labeling the dataset with descriptive variable names

names(extracted_data)[2] = "activity"
names(extracted_data)<-gsub("^t", "time", names(extracted_data))
names(extracted_data)<-gsub("^f", "frequency", names(extracted_data))
names(extracted_data)<-gsub("Acc", "accelerometer", names(extracted_data))
names(extracted_data)<-gsub("Gyro", "gyroscope", names(extracted_data))
names(extracted_data)<-gsub("Mag", "magnitude", names(extracted_data))
names(extracted_data)<-gsub("BodyBody", "body", names(extracted_data))
names(extracted_data)<-gsub("tBody", "TimeBody", names(extracted_data))


# creating independent tidy dataset

independent_data <- extracted_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(independent_data, "independent data.txt", row.name = F)








##R code for week 4 quiz - data cleaning course

filename <- "week4quiz.zip"
# Checking if archieve already exists
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
} 

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#Merging testing and training

train<-cbind(subject_train,x_train, y_train)
test <- cbind(subject_test, x_test, y_test)

data <- rbind(train, test)

#Exctracting mean&ST
library(dplyr)
tidydata <- data %>% select(subject, code, contains("mean"), contains("std"))

#Renaming data
tidydata$code <- activities[tidydata$code, 2]

names(tidydata)[2]<-"activity"

names(tidydata)<-gsub("Acc", "accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "body", names(tidydata))
names(tidydata)<-gsub("Mag", "magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "time", names(tidydata))
names(tidydata)<-gsub("^f", "frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "timeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "SD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "angle", names(tidydata))
names(tidydata)<-gsub("gravity", "gravity", names(tidydata))


#summarise by mean and save
average_data <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.csv(average_data, "average_data.csv")









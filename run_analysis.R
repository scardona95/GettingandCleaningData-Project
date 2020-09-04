setwd("C:/Users/Sofi/Desktop/Coursera")

# FIRST DOWNLOAD THE FILE

if(!file.exists("./dataset")) {dir.create("./dataset")}

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileurl, destfile = "./dataset/ProjectGCD.zip")

#UNZIP THE DATA

unzip(zipfile = "./dataset/ProjectGCD.zip", exdir = "./dataset")

list.files("./dataset") #THE UNZIP DATA WAS SAVE IN THE UCI HAR DATASET FOLDER.

#TAKING A LOOK OF THE FILES

path <- file.path("./dataset" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

setwd("C:/Users/Sofi/Desktop/Coursera/dataset/UCI HAR Dataset")

#1.Merges the training and the test sets to create one data set.

#1.1 Reading the files

#1.1.1 Reading features descriptions
features <- read.table("./features.txt", col.names = c("n","functions")) 

#1.1.2 Reading activity labels 
activity_labels <- read.table("./activity_labels.txt", col.names = c("id", "activity")) 

#1.1.3 Reading the training datasets
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "id")
s_train <- read.table("train/subject_train.txt", col.names = "subject")

#1.1.4 Reading the test datasets
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "id")
s_test <- read.table("test/subject_test.txt", col.names = "subject")


#1.2 Merging the data
data_x <- rbind(x_train, x_test)
data_y <- rbind(y_train, y_test)
data_s <- rbind(s_train, s_test)
all_data<- cbind(data_s, data_y, data_x)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

DataMeanandStd <- all_data %>% select(subject, id, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set

DataMeanandStd$id <- activity_labels[DataMeanandStd$id, 2]
names(DataMeanandStd)[2] = "activity"

#4. Appropriately labels the data set with descriptive variable names.

#Note that I already tagged the columns Subject and Activity, so I'll rename the rest of the variables

names(DataMeanandStd)<-gsub("Acc", "Accelerometer", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("Gyro", "Gyroscope", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("BodyBody", "Body", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("Mag", "Magnitude", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("^t", "Time", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("^f", "Frequency", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("tBody", "TimeBody", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("-mean()", "Mean", names(DataMeanandStd), ignore.case = TRUE)
names(DataMeanandStd)<-gsub("-std()", "STD", names(DataMeanandStd), ignore.case = TRUE)
names(DataMeanandStd)<-gsub("-freq()", "Frequency", names(DataMeanandStd), ignore.case = TRUE)
names(DataMeanandStd)<-gsub("angle", "Angle", names(DataMeanandStd))
names(DataMeanandStd)<-gsub("gravity", "Gravity", names(DataMeanandStd))

#5. From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

#Creating a new tidy data set
TidySet <- DataMeanandStd %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

#Saving the new data set
write.table(TidySet, "TidySet.txt", row.name=FALSE)








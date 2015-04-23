library(dplyr)
library(reshape2)
#Merges the training and the test sets to create one data set.
        
        #Read Files
        features <- read.table("features.txt")
        activities <- read.table("activity_labels.txt")
        subject_test <- read.table("subject_test.txt")
        subject_train <- read.table("subject_train.txt")
        x_test <- read.table("X_test.txt")
        x_train <- read.table("X_train.txt")
        y_test <- read.table("y_test.txt")
        y_train <- read.table("y_train.txt")
        
        #Merge files
        test <- cbind(subject_test, y_test, x_test)
        train <- cbind(subject_train, y_train, x_train)
        
        #Add column names
        names(activities) <- c("activityID", "activityName")
        names(features) <- c("ID","variable")
        
        #Merge all data
        allData <- rbind(test, train)
        allLabels <- c("subject", "activityID", as.vector(features$variable))

#Extracts only the measurements on the mean and standard deviation for each measurement. 
        names(allData) <- c("subject", "activityID", as.vector(features$variable))
        wantedLabels <- c("subject", "activityID", grep("mean|std", allLabels, value=TRUE))
        
        wantedData <- allData[,wantedLabels]


#Uses descriptive activity names to name the activities in the data set
        
        wantedData <- arrange(merge(wantedData, activities, by.x="activityID", by.y="activityID"),subject, activityID)
        


#Appropriately labels the data set with descriptive variable names. 

        #names(allData) <- c("subject", "activityID", as.vector(features$variable))
        #names(train) <- c("subject", "activityID", as.vector(features$variable))
        

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
        #for each activity and each subject.

        dataMelt <- melt(wantedData, id=c("subject", "activityID", "activityName"), measure.vars=grep("mean|std", allLabels, value=TRUE))
        summarizedData <- dcast(dataMelt, subject+activityName~variable, mean)

        write.table(summarizedData, file = "tidysummarizeddataset.txt", row.name=FALSE)
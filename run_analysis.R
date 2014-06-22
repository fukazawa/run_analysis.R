library(reshape2)

#
# 1.Merges the training and the test sets to create one data set.
#

#get test data
test_sub  <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
test_x    <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
test_y    <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")

#get train data
train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
train_x   <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
train_y   <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")

#get name labels
collabel <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

#merge subject
subject <- rbind(test_sub, train_sub)
colnames(subject) <- "subject"

#merge activity
activity_names <- rbind(test_y, train_y)
activity_names <- merge(activity_names, activity, by=1)[,2]

#merge data
data_all <- rbind(test_x, train_x)
colnames(data_all) <- collabel[, 2]
data_all <- cbind(subject, activity_names, data_all)

#
# Extracts only the measurements on the mean and standard deviation 
#   for each measurement. 
#
mean_row_flags <- grep("mean()",colnames(data_all),fixed=TRUE)
std_row_flags <- grep("std()",colnames(data_all),fixed=TRUE)
grep_data <- data_all[,c(1,2,mean_row_flags,std_row_flags)]

#
# Creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject
#
melt_data = melt(grep_data, id.var = c("subject", "activity_names"))
means = dcast(melt_data , subject + activity_names ~ variable, mean)

#result
write.table(means, file="./data.txt")
means

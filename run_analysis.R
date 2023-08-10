setwd("C:/Users/18922361/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

features <- read.table("features.txt") ##get labels for the X_train df

activityLabels <- read.table("activity_labels.txt")

train.data <- read.table("train/X_train.txt") ##making train data frame 
train.labels <- read.table("train/Y_train.txt") ##get excercise label
train.subject <- read.table("train/Subject_train.txt") ##get subject label

colnames(train.data) <- features[, 2] ##merge feature names with train columns 
colnames(train.labels) <- "ActivityId" ##better names 
colnames(train.subject) <- "SubjectId"

Train.df<- cbind(train.subject, train.labels, train.data) ##merge all 

##repeat with Test data 
test.data <- read.table("test/X_test.txt")
test.labels <- read.table("test/Y_test.txt")
test.subject <- read.table("test/Subject_test.txt")

colnames(test.data) <- features[, 2]
colnames(test.labels) <- "ActivityId"
colnames(test.subject) <- "SubjectId"

Test.df<- cbind(test.subject, test.labels, test.data)

df <- rbind(Test.df, Train.df) ##merge test and train data 


##get names of the columns in order to search for the mean data 
findnames <- colnames(df) 
##find the mean and std data 
find.data <- (grepl("ActivityId" , findnames,) | grepl("SubjectId" , findnames) | grepl("mean.." , findnames) | grepl("std.." , findnames))
##subset by mean and data column names 
msdf <- df[, find.data == TRUE] 
##include activity names instead of the numbers (as per what defines clean data)
msdf1 <- merge(msdf, activityLabels, by.x = "ActivityId", by.y = "V1")
colnames(msdf1)[82] = "Activityname"

##average data and reorder
Final <- aggregate(. ~SubjectId + Activityname, msdf1, mean)
Final <- Final[order(TidySet$SubjectId, TidySet$Activityname),]

##print to text file 
write.table(Final, "Course_3_final.txt", row.name=FALSE)



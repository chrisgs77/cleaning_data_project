# required libraries
library(dplyr)

#assign filename based on data source and then read to local directory
zipfile<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfile,'project.zip',method="curl")
unzip("project.zip")

#get all features descriptions
features<-read.table("UCI HAR Dataset/features.txt")
names(features)<-c("FeatureID","FeatureName")

#subset to those eature that are mean or std 
to_keep<-grep("mean\\(\\)|std\\(\\)",features$FeatureName)
features<-features[to_keep,]

#read feature data for all subjects and subset to those of interest
feat_train<-read.table("UCI HAR Dataset/train/X_train.txt")
feat_train<-feat_train[,to_keep]
feat_test<-read.table("UCI HAR Dataset/test/X_test.txt")
feat_test<-feat_test[,to_keep]
feat_all<-rbind(feat_train,feat_test)

#name the columns and make descriptive
names(feat_all)<-t(features$FeatureName)
names(feat_all)<-gsub("-mean\\(\\)"," Mean",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("-std\\(\\)"," STD",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("^f","FFT ",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("^t","Time ",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("acc"," Accelerometer",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("mag"," Magnitude",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("gyro"," Gyroscope",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("bodybody","Body",names(feat_all),ignore.case=T)
names(feat_all)<-gsub("jerk"," Jerk",names(feat_all),ignore.case=T)

#read subjects
train_sub<-read.table("UCI HAR Dataset/train/subject_train.txt")
names(train_sub)<-"subjectID"
test_sub<-read.table("UCI HAR Dataset/test/subject_test.txt")
names(test_sub)<-"subjectID"

#read activity labels/features and rename
labels<-read.table("UCI HAR Dataset/activity_labels.txt")
names(labels)<-c("ActivityID","ActivityName")
train_act<-read.table("UCI HAR Dataset/train/y_train.txt")
names(train_act)<-"ActivityID"
train_act<-inner_join(train_act,labels)
test_act<-read.table("UCI HAR Dataset/test/y_test.txt")
names(test_act)<-"ActivityID"
test_act<-inner_join(test_act,labels)

#set all files together
train<-cbind(train_sub,train_act)
test<-cbind(test_sub,test_act)
comb<-rbind(train,test)
combine_all<-cbind(comb,feat_all)



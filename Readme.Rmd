---
title: "ReadMe"
author: "TRM 8-22-14"
date: "August 22, 2014"
output: html_document
---

This document explains the work I did for the course assigment for Getting and Cleaning Data.
A separate file "Code Book 8-22-14.pdf" provides summary of variable outputs from this work.

A summary description of the assignment from the course website:

_The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected._

_One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:_

_http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones_

_Here are the data for the project:_

_https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip_

_You should create one R script called ```run\_analysis.R``` that does the following._

_1. Merges the training and the test sets to create one data set._
_2. Extracts only the measurements on the mean and standard deviation for each measurement._
_3. Uses descriptive activity names to name the activities in the data set._
_4. Appropriately labels the data set with descriptive variable names._
_5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject._

Having downloaded and extracted the zip file into a directory called "UCI HAR Dataset", the function run_analysis() proceeds to execute the steps outlined above.

Step 1a.  Read in the training set, combine properly against subject and activities

``` 
        ##read in training data, activities and subjects and put them together
        traindata<-read.table("./train/X_train.txt")
        trainactivities<-read.table("./train/y_train.txt")
        trainsubjects<-read.table("./train/subject_train.txt")
        data1<-cbind(trainsubjects,trainactivities,traindata)
```

Step 1b.  Do the same for the test data.
```
        ##read in testing data, activities and subjects and put them together
        testdata<-read.table("./test/X_test.txt")
        testactivities<-read.table("./test/y_test.txt")
        testsubjects<-read.table("./test/subject_test.txt")
        data2<-cbind(testsubjects,testactivities,testdata)
```

Step 1c.  Combine them into one big data set and add appropriate variable names.
```
        ##put together testing and training data into one big data set
        data<-rbind(data1,data2)
        
        ##read in column names and apply to big data set
        labels<-read.table("features.txt")
        labels<-labels[,2]
        labels<-as.vector(labels)
        newlabels<-c("subject","activity",labels)
        names(data)<-newlabels
```

Step 2.  Reduce the dataset to include on those columns/variables related to means and standard deviations.

```
        ##extract those columns representing std or mean
        stdlabels<-grep("std",newlabels)
        meanlabels<-grep("mean",newlabels)
        meanstdlabels<-c(meanlabels,stdlabels)
        meanstdlabels<-meanstdlabels[order(meanstdlabels)]
        data<-data[,c(1:2,meanstdlabels)]
```

Step 3.  Make the activity variable reflect more descriptive information.
```
        ##changes activity variable to a more descriptive name
        activitylabels<-c("walking","walkingupstairs","walkingdownstairs","sitting","standing","layingdown")
        data$activity<-factor(data$activity,labels=activitylabels)
```

Step 4.  Clean up variable names generally.  I took two views regarding this step.  (1)  I deleted all special characters, and (2) I generally preserved uppercase segments as believe this increases readability.

```
        ##clean up column names.  left upper case/lower case on purpose
        names(data)<-gsub("-|\\()", "", names(data))
```

Step 5.  Calculated means by activity, by subject and wrote the resulting table to a .txt file.
```
        ##create table that calculates mean of 561 vars by activity, by subject
        answer<-aggregate(.~activity+subject,data=data,FUN=mean)

        ##write data set to a file
        write.table(answer,"answer.txt",row.name=FALSE)
```

This gives me a data table that looks as follows: ```head(answer[,1:6])```

```
        activity subject tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ tBodyAccstdX
1           walking       1     0.2773308  -0.017383819    -0.1111481  -0.28374026
2   walkingupstairs       1     0.2554617  -0.023953149    -0.0973020  -0.35470803
3 walkingdownstairs       1     0.2891883  -0.009918505    -0.1075662   0.03003534
4           sitting       1     0.2612376  -0.001308288    -0.1045442  -0.97722901
5          standing       1     0.2789176  -0.016137590    -0.1106018  -0.99575990
6        layingdown       1     0.2215982  -0.040513953    -0.1132036  -0.92805647
```


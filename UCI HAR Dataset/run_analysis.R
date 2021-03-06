run_analysis<-function(){
        setwd("./cleandatacourse/cleandata/UCI HAR Dataset")
        
        ##read in training data, activities and subjects and put them together
        traindata<-read.table("./train/X_train.txt")
        trainactivities<-read.table("./train/y_train.txt")
        trainsubjects<-read.table("./train/subject_train.txt")
        data1<-cbind(trainsubjects,trainactivities,traindata)
        
        ##read in testing data, activities and subjects and put them together
        testdata<-read.table("./test/X_test.txt")
        testactivities<-read.table("./test/y_test.txt")
        testsubjects<-read.table("./test/subject_test.txt")
        data2<-cbind(testsubjects,testactivities,testdata)
        
        ##put together testing and training data into one big data set
        data<-rbind(data1,data2)
        
        ##read in column names and apply to big data set
        labels<-read.table("features.txt")
        labels<-labels[,2]
        labels<-as.vector(labels)
        newlabels<-c("subject","activity",labels)
        names(data)<-newlabels
        
        ##extract those columns representing std or mean
        stdlabels<-grep("std",newlabels)
        meanlabels<-grep("mean",newlabels)
        meanstdlabels<-c(meanlabels,stdlabels)
        meanstdlabels<-meanstdlabels[order(meanstdlabels)]
        data<-data[,c(1:2,meanstdlabels)]
        
        ##changes activity variable to a more descriptive name
        activitylabels<-c("walking","walkingupstairs","walkingdownstairs","sitting","standing","layingdown")
        data$activity<-factor(data$activity,labels=activitylabels)

        ##clean up column names.  left upper case/lower case on purpose
        names(data)<-gsub("-|\\()", "", names(data))

        ##create table that calculates mean of 561 vars by activity, by subject
        answer<-aggregate(.~activity+subject,data=data,FUN=mean)

        ##write data set to a file
        write.table(answer,"answer.txt",row.name=FALSE)

        ##return data table to function call
        answer
}
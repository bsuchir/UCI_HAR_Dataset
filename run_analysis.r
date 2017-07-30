library(dplyr)
library(tidyr)


#Let us go and understand the files in the directory of this data set 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset")


#Ok, i will first work with the training data to get a better hang of the data 

#we will first read the data in R 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset/train")
X_train_data<-read.table("X_train.txt")

#let us now understand and label the data 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset")
features_labels<-read.table("features.txt")
colnames(X_train_data)<-features_labels[,2]

#Let us now load the y_train data 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset/train")
y_train_data<-read.table("y_train.txt")
colnames(y_train_data)<-"Activity Label"

#we will now combine the x and y data 
Combined_train_data<-cbind(X_train_data,y_train_data)

#to make it more self explicit for us, let us add another column with the names 
#of the activities 
#let us read the names of the activites
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset")
activity_label<-read.table("activity_labels.txt")
activity_label_col_number <-ncol(Combined_train_data)

for (i in 1:nrow(Combined_train_data)) {
      activity_label_index <-Combined_train_data[i,activity_label_col_number]
      Combined_train_data[i,activity_label_col_number+1] <-as.character(activity_label[activity_label_index,2])
}
colnames(Combined_train_data)[activity_label_col_number+1]<-"Activity Name"

#Let us now read the subject variable and bind it to the observations 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset/train")
subject_train<-read.table("subject_train.txt")
colnames(subject_train)<-"Subject Number"
Combined_train_data<-cbind(Combined_train_data,subject_train)

#let us now read the test data 
# am not commenting this section as the steps to be followed are the same as train set 
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset/test")
X_test_data<-read.table("X_test.txt")
colnames(X_test_data)<-features_labels[,2]
y_test_data<-read.table("y_test.txt")
colnames(y_test_data)<-"Activity Label"
Combined_test_data<-cbind(X_test_data,y_test_data)

activity_label_col_number <-ncol(Combined_test_data)

for (i in 1:nrow(Combined_test_data)) {
        activity_label_index <-Combined_test_data[i,activity_label_col_number]
        Combined_test_data[i,activity_label_col_number+1] <-as.character(activity_label[activity_label_index,2])
}
colnames(Combined_test_data)[activity_label_col_number+1]<-"Activity Name"
subject_test<-read.table("subject_test.txt")
colnames(subject_test)<-"Subject Number"
Combined_test_data<-cbind(Combined_test_data,subject_test)

#We are now going to merge the train and test data set as our train and test 
#data set is now labelled and ready to be merged 
Combined_data<-rbind(Combined_train_data,Combined_test_data)

#We will now extract out only the columns which contain the mean and std()
#One should be careful here to use mean() as there are functions which have 'mean'
#in their name and are to be not added to this list 
mean_indices<-grep("mean\\(\\)",colnames(Combined_data),ignore.case=F)
std_indices<-grep("std\\(\\)",colnames(Combined_data),ignore.case=F)

#Let us now combine the 2 lists and then sort it to get an ordered list of columns 
all_indices<-append(mean_indices,std_indices)

#We also need to add the columns for the activity no., activity name, subject number 
other_indices<-c(562,563,564)
all_indices<-append(all_indices,other_indices)

#Let us now sort the list to make it more readable so that data stays in same order as original 
#data set 
sorted_all_indices<-sort(all_indices)

Filtered_combined_data<-Combined_data[,sorted_all_indices]

#Let us now change to long format we will change all columns execpt the last 3 which act as our
#row identifiers i.e. activity label, activity name, subject number 
gathered_data<-gather(Filtered_combined_data,Parameter,Measurement,1:66,na.rm=TRUE)

#After gathering we will group the data based on the 4 parameters on which we need to take average
gathered_summarized_data<-group_by(gathered_data,`Activity Label`,`Activity Name`,`Subject Number`,Parameter,add=TRUE) %>%
        summarise(Measurement = mean(Measurement))

#We now need to go back from long format to wide format 
#In this we leave activity label, name and subject number as row labels, all means will go 
# to columns 
tidy_data <- spread(gathered_summarized_data,Parameter,Measurement)

#Let us now output the data to a file 
#write.csv(tidy_data,file="tidy_output.csv")
setwd("/Users/suchir/Documents/GitHub/UCI_HAR_Dataset")
write.table(tidy_data,file="tidy_output.txt",row.names = F)

# UCI_HAR_Dataset
In this exercise we are given data about 30 subjects for 6 activities using various measurements. We are supposed to summarize and show the mean and std data for these various measurements. 

There are 2 given datasets, hence first thing to do is to understand how the data looks like and I decided to start with the train data. 

1. Open the train data and load the X_train file.  
2. We would now need to put the labels on these columns for which we refer to the file features.txt. 
3. We now opened the second file in the train set - called y_train.txt which tells us the activity numbers for which the data is given. This was then combined with the X_train data. 
4. However, this only tell us the activity numbers which is not very intutive hence we need to put the activity names. For this we open the file activity_labels and put the corresponding names there. 
5. This is then combined with the previous data. 
6. Next we open the file subject_train which tell us the row data is for which subject, this is also combined with the combined data we have been preparing. 
7. The training data is now ready with labels and all columns in place. 
8. We repeated these step for the test data. 
9. The combined_test and combined_train data are now combined to make one file. 
10. We now put a filter on the columns to only choose the columns whose names have mean() and std(). its important to make sure we don't choose columns which have mean in the name. We also have to combine the activity name, label and subject number with these in 1 file. 
11. We then use gather to make the data in long format. 
12. We then use groupby() and summarize to get the mean of the parameters for activity label, activity name, subject number and parameter. 
13. This data is then converted to wide format using spread in which 1 row gives us the mean of all the parameters for 1 subject and 1 activity combination - hence 180 rows 
14. The final cleaned up data is produced in the file tidy_output.txt 

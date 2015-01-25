Sources and info about the data used.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


I use the following files from provided data in my script.

And I have a code block at the beginning that checks for the existance of the download data before continuing.

test/X_test.txt
test/y_test.txt
test/subject_test.txt

train/X_train.txt
train/y_train.txt
train/subject_train.txt

features.txt

My intial steps are to read the data in from the test data, test activity labels and subjects.
I column bind the subject and activity columns to the data to create a single test table.
I then properly name the subject and activity_label columns since they do not exist in the features table I will be using later.

I then perform the identical steps with the training data.

I then remove the temporary tables from memory.

This leaves me with two tables test_data and train_data respectively.

I then do an rbind on the test and train tables, storing the result in a new data table.

I then remove the temporary tables from memory.

I then read in the features file, and store its contents in a features data table.
I then  filter all of the columns that are not related to the Mean and STD from the features table, using filter with a grep statement.

I could not determine from the directions whether 'meanFreq' was included or not and determined that it was not, so removed it at this stage.

I create two vectors one with the column positions from the features and a second with the column names.
feature_columns and feature_labels.
These vectors make it easier to properly name and modify the data table later.

I then loop through the number of features and properly name each of the columns we are going to keep, using the names plain text descriptive names from the features file.
I then add the subject and activity columns to the feature columns vector, since I will be using it to select the columns we want to keep.
I insert them at the beginning of the vector because I want subject and activity to be the first two columns in the resulting data set.

I then use a dplyr select statement passing in the columns numbers to keep which are in the feature_columns vector and storing it in a results table.
This removes all of the columns that we are not interested in. Leaving only the mean and STD. 

I then replace the Activity Label column numeric values with the matching text from the activity_labels.txt file.

At this point it is simple to chain a group and summarize_each commmand to create the new tidy, data set.
I got the summarize each idea from http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr.

At this point I am left with two data tables: 

result - which is the tidy data table with every observation for each subject and activity.
new_tidy_data - which is the summarized verions showing the mean/average for each subject and activity.


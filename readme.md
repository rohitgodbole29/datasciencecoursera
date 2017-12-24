Human Activity Recognition Using Smartphones Dataset
The following steps have been carried out:
1. load the various libraries like dplyr,rlist,stringr etc.
2. use read.table to load the training and test data sets.
3. also load the subject and the activity list files.
4. The dimensions of subject , activity and training andtest are such that they can be merged as follows:
a) first combine subject and test && subject and Y_train  using bind_cols respectively
b) use the output of step a to combine seperately with X_test and X_train
c) finally combine row wise the output of step b.

5. Next use the grepl function to identify a list of index (boolean mask) for identifying the mean and std from the features.txt file
6.Next proceed to clean up the variable names.
7. Convert the activity codes into activity in text, by indexing a lookup into the dataframe.
8.Further clean up the variables.
9. Remove duplicates combination of subject and activity, by using the mean values, as subsititute of the range of values.
10. The resultant datset is now tidy and is written to a text file.
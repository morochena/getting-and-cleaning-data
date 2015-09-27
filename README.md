# Getting and Cleaning Data Project

1. Install `data.table` and `reshape2` packages. 
2. Run the script, it should download and unzip the dataset if it does not already exist.
3. It loads both the training and test datasets, and removes columns that are not the standard deviation or mena.
4. It loads the activity and subject data for each dataset and merges them with the test and training data.
5. It combines both datasets.
6. It converts the activity and subject columns into factors
7. It creates a new clean dataset that consists of the mean value of each variable for each subject and activity pair.


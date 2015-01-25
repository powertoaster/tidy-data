run_analysis <- function()
  # Sanity checks, is the downloaded data present
  continue <- file.exists("~/UCI HAR Dataset")
  continue <- setwd("~/UCI HAR Dataset")

  # Add test data labels from Y to X 
  test_data = read.table("test/X_test.txt")
  test_label = read.table("test/y_test.txt")
  test_subject = read.table("test/subject_test.txt")

  # Bind the activity label to the data
  test_data <- cbind(test_data, test_label)
  # rename the label column
  colnames(test_data)[562] <- 'activity_label'

  # Bind the subject to the data
  test_data <- cbind(test_data, test_subject)
  # rename the label column
  colnames(test_data)[563] <- 'subject'

  # Cleanup the temporary variables
  remove(test_label)
  remove(test_subject)

  # Add train data labels from Y to X
  train_data = read.table("train/X_train.txt")
  train_label = read.table("train/y_train.txt")
  train_subject = read.table("train/subject_train.txt")
  
  # Bind the activity label to the data
  train_data <- cbind(train_data, train_label)
  # rename the label column
  colnames(train_data)[562] <- 'activity_label'
  
  # Bind the subject to the data
  train_data <- cbind(train_data, train_subject)
  # rename the label column
  colnames(train_data)[563] <- 'subject'

  # Cleanup the temporary variables
  remove(train_label)
  remove(train_subject)

  # Merge train and test data
  # The columns are the same so a simple rbind will suffice
  data <- rbind(test_data, train_data)

  # Cleanup the temporary variables
  remove(train_data)
  remove(test_data)

  # Name the columns, It is easier to do this here since the column definitions in the features.txt file already have the column indexes for us.
  features <- read.table("features.txt")

  # Get only the columns that have std() or mean()
  features <- filter(features, grepl('mean()|std()', V2))
  
  # I could not determine form the directions wether 'meanFreq' was included or not and determined that it was not
  # So I remove it here
  features <- filter(features, !grepl('meanFreq', V2))
  feature_labels <- as.character(features$V2)  
  feature_columns <- as.numeric(features$V1)
  
    # Rename the columns
  for (i in 1:nrow(features)) {
    colnames(data)[features$V1[i]] <- feature_labels[i]
  }
  
  # insert the activity and subject columns at the beginning
  feature_columns <- append(feature_columns,563:562, after = 0)


  # Select only the desired columns from above
  result <- select(data, feature_columns)

  # Use descriptive activity names
  result <- mutate(result, activity_label = ifelse(activity_label == 1, 'WALKING', activity_label))
  result <- mutate(result, activity_label = ifelse(activity_label == 2, 'WALKING_UPSTAIRS', activity_label))
  result <- mutate(result, activity_label = ifelse(activity_label == 3, 'WALKING_DOWNSTAIRS', activity_label))
  result <- mutate(result, activity_label = ifelse(activity_label == 4, 'SITTING', activity_label))
  result <- mutate(result, activity_label = ifelse(activity_label == 5, 'STANDING', activity_label))
  result <- mutate(result, activity_label = ifelse(activity_label == 6, 'LAYING', activity_label))

  # Group by Subject and Activity
  # sumarize_each from http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr
  new_tidy_data <- result %>% group_by(subject, activity_label) %>% summarise_each(funs(mean))
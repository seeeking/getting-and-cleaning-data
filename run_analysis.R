
## set path and load package
library(dplyr)
library(tidyr)
setwd("D:\\working folder\\UCI HAR Dataset")

## load data files
file1 <- "train/X_train.txt"
X_train <- read.table(file1, na.strings = "N/A")

file2 <- "train/Y_train.txt"
Y_train <- read.table(file2, na.strings = "N/A")

file3 <- "test/X_test.txt"
X_test <- read.table(file3, na.strings = "N/A")

file4 <- "test/Y_test.txt"
Y_test <- read.table(file4, na.strings = "N/A")

file5 <- "train/subject_train.txt"
file6 <- "test/subject_test.txt"
subject_train <- read.table(file5, na.strings = "N/A")
subject_test <- read.table(file6, na.strings = "N/A")

filenames <- "features.txt"
features <- read.table(filenames)
ac_labels <- "activity_labels.txt"
ac_names <- read.table(ac_labels)

## change Y_train/Y_test from int to description
ac_names <- as.character(ac_names[,2])
Y_train <- as.data.frame(ac_names[Y_train$V1])
Y_test <- as.data.frame(ac_names[Y_test$V1])

## give every data frame a descriptive colname
names <- as.character(features[,2])
names(X_train) <- names
names(Y_train) <- "activity"
names(X_test) <- names
names(Y_test) <- "activity"
names(subject_train) <- "subject"
names(subject_test) <- "subject"

## main process, select those names with "mean" and "std" in it, add a "train/test" label
## merge subject and activity_labels to the new data
X_train_new <- X_train %>%
  select(contains("mean"), contains("std")) %>%
  mutate(label = "train")
X_train_new <- cbind(subject_train, Y_train, X_train_new)

X_test_new <- X_test %>%
  select(contains("mean"), contains("std")) %>%
  mutate(label = "test")
X_test_new <- cbind(subject_test, Y_test, X_test_new)

## merge the training and test data, change order of columns for the convience of printing
datatidy <- rbind(X_train_new, X_test_new)
datatidy <- datatidy[, c(1, 2, 89, 3:88)]
print(datatidy[1:10,1:6])

## write the tidy data to file
write.table(datatidy, file = "datatidy.txt", row.name=FALSE)

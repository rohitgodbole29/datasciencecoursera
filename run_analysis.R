# load libraries
library(data.table)
library(dplyr)
library(rlist)
library(stringr)
library(purrr)

filepath1<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\train\\X_train.txt"

df1 <- read.table(file = filepath1,header = FALSE)

# now similarly we need to read from the test set.


filepath2<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\test\\X_test.txt"
df2 <- read.table(file = filepath2,header = FALSE)

#similarly read for y_test


filepath3<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\test\\y_test.txt"
df3 <- read.table(file = filepath3,header = FALSE)

filepath4<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\train\\y_train.txt"
df4 <- read.table(file = filepath4,header = FALSE)

filepath5<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\train\\subject_train.txt"
df5 <- read.table(file = filepath5,header = FALSE)

filepath6<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\test\\subject_test.txt"
df6 <- read.table(file = filepath6,header = FALSE)


# Now first combine subject and test. && train and subject

df36<-bind_cols(df3,df6)
df45<-bind_cols(df4,df5)

# Now combine df36 and df2 and combine df45 and df1
df236<- bind_cols(df36,df2)
df451<-bind_cols(df45,df1)


# now combine the rows of df236 and df451

df<- bind_rows(df236,df451)
# remove the earlier dfs
rm(df1)
rm(df2)
rm(df3)
rm(df4)
rm(df5)
rm(df6)
rm(df36)
rm(df45)
rm(df236)
rm(df451)
################################################
# Now let us do a grepl function to find the index for the mean() in the txt file. We shall use this index to extract relevant cols
# from the data frame.

filepath7<- "E:\\johns hopkins\\Cleaning Data course\\wk4\\UCI HAR Dataset\\features.txt"
df7 <- read.table(file = filepath7,header = FALSE)
mask<- grepl(pattern = "(.*)mean(.*) |(.*)mean()(.*)|(.*)std(.*) |(.*)std()(.*)",x = df7$V2)
table(mask)

# extract the variables from df7
var_list<- as.character(df7[mask,]$V2)
# let us prepend the first two variables subject_ids, activity_names
var_list<-list.prepend(.data = var_list,c("subject","activity_names"))
# becasue we have add two variable at the beggining , we need to pre-append the mask list.
mask<-list.prepend(.data = mask,c(1,1))
mask<-as.logical(mask)
# extract only the relevant columns
smalldf<- df[,mask]
# remove df7 and df
rm(df7)
rm(df)
# small df is our target data frame.

# build a look-up vector
lookup_vector<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
# index this lookup]
smalldf$V1<-lookup_vector[smalldf$V1]
#var_list
# take-off the means out of the column names.
var_list<-sub(pattern = "mean|mean()|std|std()|()",replacement = "",x = var_list)
var_list<-sub(pattern = "-()|()-|\\(|\\)",replacement = "",x = var_list)
var_list<-sub(pattern = "BodyBody",replacement = "Body",x = var_list)
# now we can rename the col names.
# we can clean using make.names
colnames(smalldf)<-make.names(str_trim(var_list))

# now create a tidy set from smalldf
# let us collapse the number of observations for same combination of subject /activity.
len1<-length(colnames(smalldf))
newdf<-smalldf%>%group_by(subject,activity_names)%>%
  summarise_at(.vars = colnames(smalldf)[3:len1],.funs = mean,na.rm=TRUE)

rm(smalldf)

# Now write the tidy dataframe.

write.table(x = newdf,file = "E:\\johns hopkins\\Cleaning Data course\\wk4\\tidy.txt",row.names = FALSE)

rm(newdf)
#end














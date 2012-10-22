## na.string is: a character vector of strings which are to be interpreted as NA values

data1=read.csv("D:\\hsong\\SkyDrive\\r_temp\\visitnew_summary.csv",header=T,na.strings=".")

###R

### read in data, treat missing data period (.) as NA.
data1<-read.csv("D:\\SkyDrive\\r_temp\\visitnew_summary.csv",header=T,na.strings=".")

###  impute missing as 0
data1[is.na(data1)]<-0

###  calculate mean of visits revenue clicks at publisher_id and category_id level
aggregate(cbind(visits, revenue, clicks)~PUBLISHER_ID+category_id, data1, sum)->data1_sum

###  or we can use aggregate in this way
aggregate(data1[c("visits","revenue","clicks")],by=list(publisher_id=data1$PUBLISHER_ID,category_id=data1$category_id),sum)

###  sort the data by asending publisher_id and category_id
data1_sum[with(data1_sum,order(PUBLISHER_ID,category_id)),]

###  weighted mean: mean of revenue wegithed by visits at publisher_id category_id level
by(data1, list(publisher_id=data1$PUBLISHER_ID,category_id=data1$category_id), function(data1) weighted.mean(data1$revenue,data1$visits))




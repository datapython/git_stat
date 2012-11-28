st=ls())
rpvdata<-read.csv("D:\\hsong\\SkyDrive\\Public\\landing_page_rpv\\landing_page_rpv.csv",header=T, skip=2)
rpvdata=rpvdata[product_count>0,]
head(rpvdata)
names(rpvdata)<-tolower(names(rpvdata))
sapply(rpvdata, class)
rpvdata$lprpv=rpvdata$projected_rpv
attach(rpvdata)
plot(lprpv, actrpv, col="blue", main="plot of lprpv vs actrpv")

## bucket data into 20 buckets like sas proc rank did
lprpv_rank<-cut(lprpv, breaks=quantile(lprpv, probs=c(0:20/20)), labels=0:19, include.lowest=T, right=F)
table(lprpv_rank)
## calculate mean of lprpv in each lprpv_rank
tapply(lprpv, lprpv_rank, mean)
## calculate weighted mean
library(plyr)
df_wtm<-as.data.frame(cbind(lprpv, actrpv, lprpv_rank, visits_wt))
lprpv_m<-ddply(df_wtm, .(lprpv_rank), function(x) data.frame(lprpv_mean=weighted.mean(x$lprpv, x$visits_wt)))
actrpv_m<-ddply(df_wtm, .(lprpv_rank), function(x) data.frame(actrpv_mean=weighted.mean(x$actrpv, x$visits_wt)))
overall_wt_m<-merge(lprpv_m, actrpv_m, by="lprpv_rank")
## linear regression without product_count information
lm(actrpv_mean ~ lprpv_mean, data=overall_wt_m)

### next include prod_cnt_flag in the analysis
## generate flag variables like sas format did
cutf=function(x) cut(x, breaks=quantile(x, probs=c(0:20/20)), labels=0:19, include.lowest=T, right=F)
prod_cnt_flag<-ifelse(product_count==0, 0, ifelse(product_count==1,1,ifelse(product_count==2,2,ifelse(product_count==3,3,4))))
overall_m=list()
for (i in 1:4){
  lprpv_rank<-cut(lprpv[product_count==i], breaks=quantile(lprpv[product_count==i], probs=c(0:20/20)), labels=0:19, include.lowest=T, right=F)
  df_wtm<-as.data.frame(cbind(lprpv=lprpv[product_count==i], actrpv=actrpv[product_count==i], lprpv_rank, visits_wt=visits_wt[product_count==i]))
  lprpv_m<-ddply(df_wtm, .(lprpv_rank), function(x) data.frame(lprpv_mean=weighted.mean(x$lprpv, x$visits_wt)))
  actrpv_m<-ddply(df_wtm, .(lprpv_rank), function(x) data.frame(actrpv_mean=weighted.mean(x$actrpv, x$visits_wt)))
  overall_wt_m<-merge(lprpv_m, actrpv_m, by="lprpv_rank")
  overall_wt_m=data.frame(cbind(overall_wt_m, prod_cnt_group=i))
  overall_m[[i]]=overall_wt_m
  }

lprpv_rank=tapply(lprpv[product_count>0], prod_cnt_flag[product_count>0], cutf)
## in each prod_cnt_flag, calc the weighted mean 
cutf(lprpv[prod_cnt_flag==1])
df_wtm2<-as.data.frame(cbind(lprpv, actrpv, lprpv_rank, visits_wt, prod_cnt_flag))
lprpv_m=ddply(df_wtm2, .(prod_cnt_flag, lprpv_rank), function(x) data.frame(lprpv_mean=weighted.mean(x$lprpv, x$visits_wt)))


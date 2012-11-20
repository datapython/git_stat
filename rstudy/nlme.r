# this is the codes from Linear Mixed Models by John Fox in 2002

###### Part 1: Data and Data Overview

### nlme study
cat("\014")
rm(list=ls())
library(nlme)
library(lattice)
data(MathAchieve)
head(MathAchieve)
data(MathAchSchool)
head(MathAchSchool)

attach(MathAchieve)
mses=tapply(SES, School, mean)
head(mses)
detach(MathAchieve)

## create a dataframe called bryk
bryk=as.data.frame(MathAchieve[,c("School","SES","MathAch")])
names(bryk)<-tolower(names(bryk))
head(bryk)
sample20=sort(sample(7185,20))
bryk[sample20,]

bryk$meanses=mses[as.character(bryk$school)]  ## avoid using merge function
bryk$cses=bryk$ses-bryk$meanses

sector=MathAchSchool$Sector
names(sector)<-row.names(MathAchSchool)
bryk$sector=sector[as.character(bryk$school)]

###  sample two schools from each sector to plot
attach(bryk)
cat<-sample(unique(school[sector=="Catholic"]), 20)
cat.20<-groupedData(mathach~ses | school, data=bryk[is.element(school, cat),])

pub<-sample(unique(school[sector=="Public"]), 20)
pub.20<-groupedData(mathach~ses | school, data=bryk[is.element(school, pub),])

trellis.device(color=T)
# for Cathelic, the slopes are: some positive, some are almost 0, some are almost negative
xyplot(mathach~ses | school, data=cat.20, main="Catholic",
       panel=function(x,y){
       	 panel.xyplot(x,y)
	 panel.loess(x, y, span=1)
	 panel.lmline(x, y, lty=2)
	})

# for Public, the slopes are: more positive than Cathelic
xyplot(mathach~ses | school, data=pub.20, main="Public",
       panel=function(x,y){
         panel.xyplot(x,y)
         panel.loess(x,y, span=1)
      	 panel.lmline(x, y, lty=2)
       })

# linear regression for each school for each sector
cat.list<-lmList(mathach~ses | school, subset=sector=="Catholic", data=bryk)
pub.list<-lmList(mathach~ses | school, subset=sector=="Public", data=bryk)

# plot of CI for intercepts and slopes in both regressions
plot(intervals(cat.list), main="Catholic")
plot(intervals(pub.list), main="Public")

# To draw box plot to make it clear
# overall, the Catholic school have a higher level of mathach while Public school have a higher average slope
cat.coef=coef(cat.list)
head(cat.coef)
pub.coef=coef(pub.list)
head(pub.coef)

old<-par(mfrow=c(1,2))
boxplot(cat.coef[,1], pub.coef[,1], main="Intercepts", names=c("Catholic", "Public"))
boxplot(cat.coef[,2], pub.coef[,2], main="Slopes", names=c("Catholic", "Public"))
par(old)

######  Part 2: fit a hierarchical linear model with lme
bryk$sector=factor(bryk$sector, levels=c("Public", "Catholic"))
contrasts(bryk$sector)

lme(mathach ~ meanses*cses + sector*cses, random= ~ cses | school, data=bryk)->bryk.lme.1
summary(bryk.lme.1)
update(bryk.lme.1, random= ~1 | school)->bryk.lme.2  #omit random effects of cses
summary(bryk.lme.2)
anova(bryk.lme.1, bryk.lme.2)
update(bryk.lme.1, random= ~cses - 1 | school)->bryk.lme.3  #omit random intetcepts
summary(bryk.lme.3)
anova(bryk.lme.3, bryk.lme.1)
## There is strong evidence, then, that the average level of math achievement (as represented by the intercept) varies
## from school to school, but not that the coefficient of SES varies, once differences between Catholic and public
## schools are taken into account, and the average level of SES in the schools is held constant.


#######  An example in Longitudinal Data
library(car)


































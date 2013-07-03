## test the dyps banner model in R
## it is easier to do some transformation in R than in SAS

install.package("Hmisc")
library(Hmisc)

dyps=sas.get(lib="/mydata/", mem="dyps", as.is=T)

colnames(dyps)=gsub('\\.', '_', colnames(dyps))
vars=colnames(dyps)

vars_id_num=grep('id', vars)

form=paste(vars[-c(1:2, vars_id_num)], collapse="+", sep="")

dypsglm=glm(formula(paste('action~', form)), family=binomial(link="logit"), data=dyps)

summary(dypsglm)
ls(dypsglm)




*** notes from sas  proc glimmix  ***;

On average, the ratio between the Pearson statistic and its degrees of freedom should equal one in GLMs. Values larger than one indicate overdispersion. With a ratio of 2.37, these data appear to exhibit more dispersion than expected under a binomial model with block and varietal effects.

There are several possible reasons for the overdispersion noted in Output 38.1.6 (Pearson ratio = 2.37). The data might not follow a binomial distribution, one or more important effects might not have been accounted for in the model, or the data might be positively correlated.

If data are correlated, a standard generalized linear model often will indicate overdispersion relative to the binomial distribution. Two courses of action are considered in this example to address this overdispersion. First, the inclusion of G-side random effects models the correlation indirectly; it is induced through the sharing of random effects among responses from the same block. Second, the R-side spatial covariance structure models covariation directly.

proc glimmix data=HessianFly;
      class block entry;
      model y/n = block entry / dist=binomial link=logit solution;
run;

proc glimmix data=HessianFly;
      class block entry;
      model y/n = entry / solution;
      random block;
run;

 proc glimmix data=HessianFly;
       class entry;
       model y/n = entry / solution ddfm=contain;
       random _residual_ / subject=intercept type=sp(exp)(lng lat);
run;



***  know about G and R in proc mixed  ***;
******  see: http://support.sas.com/documentation/cdl/en/statug/65328/HTML/default/viewer.htm#statug_mixed_examples04.htm  ***;


























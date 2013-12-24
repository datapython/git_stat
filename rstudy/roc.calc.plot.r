library(ROCR)
library(Hmisc)

## calculate AUC from the package ROCR and compare with it from Hmisc

# method 1: from ROCR
data(ROCR.simple)
pred=prediction(ROCR.simple$prediction, ROCR.simple$labels)
perf=performance(pred, 'tpr', 'fpr')  #true positive and false negative
plot(perf, color=1)

perf2=performance(pred, 'auc')
auc=unlist(slot(perf2, 'y.values'))  # this is the AUC

# method 2: from Hmisc
rcorrstat=rcorr.cens(ROCR.simple$prediction, ROCR.simple$labels) 
rcorrstat[1]  # 1st is AUC, 2nd is Accuracy Ratio



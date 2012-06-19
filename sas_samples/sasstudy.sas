*** 1:  crontab job: suppose in sas5  ***;
***     first backup current cron:  cp sas5.cron sas5.cron20120618  ;
***     next list current cron:  crontab -l > sas5cronbefore        ;
***     change the cron, and enable it:  crontab sas5.cron          ;
***     list changed cron:  crontab -l > sas5cronafter              ;
***     diff it:  diff sas5cronbefore sas5cronafter                 ;

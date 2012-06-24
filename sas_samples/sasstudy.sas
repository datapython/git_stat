*** 1:  crontab job: suppose in sas5  ***;

***     first backup current cron:  cp sas5.cron sas5.cron20120618  ;
***     next list current cron:  crontab -l > sas5cronbefore        ;
***     change the cron, and enable it:  crontab sas5.cron          ;
***     list changed cron:  crontab -l > sas5cronafter              ;
***     diff it:  diff sas5cronbefore sas5cronafter                 ;


*** 2:  Run SAS in given MEMORY SIZE  ***;

***  check available memory size  ***;
proc options option=memsize;
run;

***  run in a given memsize   keyword: memsize   ***;
nohup sas -memsize given_mem_size ur_sas_name.sas &


  

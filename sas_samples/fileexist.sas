***  To use fileexist, take care of upcase and lowcase, case sensitive in Linux, and the surfix like  .sas7bdat  ***;

data a;
        a=fileexist("/data02/temp/temp_hsong/seo/seo_expr/seo_visitnew_raw_incr.sas7bdat");
run;

proc print data=a;
run;


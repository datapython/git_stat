options obs=10000;

libname temp "/data02/temp/temp_hsong/to_delete";

proc contents data=temp.high_vis_kws;
run;

proc sort data=temp.high_vis_kws out=high_vis_kws;
 by nrank day_of_week;
run;

proc summary data=high_vis_kws;
	by nrank day_of_week;
	var clicks visits;
	output out=classby1 sum=;
run;

proc summary data=high_vis_kws;
        class nrank day_of_week;
        var clicks visits;
        output out=classby2 sum=;
run;

title "using by";
proc print data=classby1 width=min;
run;

title "using class";
proc print data=classby2 width=min;
run;


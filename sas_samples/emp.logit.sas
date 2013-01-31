
%macro empplot(indata, xvar, yvar);

proc rank data=&indata groups=100 out=out;
	var &xvar;
	ranks bin;
run;

proc means data=out noprint nway;
	class bin;
	var &yvar &xvar;
	output out=bins sum(&yvar)=&yvar mean(&xvar)=&xvar;
run;

data bins;
	set bins;
	elogit=log((&yvar+(sqrt(_freq_)/2))/(_freq_-&yvar+(sqrt(_freq_)/2)));
run;

proc sgplot data=bins;
	reg y=elogit x=&xvar / curvelabel="Linear Relationship?"
		curvelabelloc=outside
		lineattrs=(color=ligr);
	series y=elogit x=&xvar;
	title "Empirical Logit against &xvar";
run;

proc sgplot data=bins;
	reg y=elogit x=bin / 
		curvelabel="Linear Relationship?"
		curvelabelloc=outside
		lineattrs=(color=ligr);
	series y=elogit x=bin;
	title "Empirical Logit against Binned &xvar";
run;

%mend empplot;

libname dyps "/data02/temp/temp_hsong/product_banner";

%empplot(dyps.dyps_trainoversamp2, price_change_pct, action);

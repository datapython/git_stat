
*===============================================================================================;
** use proc corr to examine the association between the inputs and the target var      		;
** Spearman corr is a corr of the ranks of the input var with the binary target,       		;
** it's less sensitive to nonlinearities and outliers then Pearson stats               		;
** Hoeffding's D statistic is also used to check the association                       		;
** if spearman rank is high and hoeffding rank is low, then the association is not monotonic	;
*===============================================================================================;
** The output is a macro var containing the selected variables by univariate screening          ;
*===============================================================================================;


%macro uniscreen(indata, varfile, target, pvalue);

filename varfile "&varfile";
** filename varfile "/home/hsong/varlist.txt";
data varall;
	infile varfile delimiter=',';
	length varname $1000.;
	input varname $ @@;
run;

proc print data=varall width=min;
title "print of varall";
run;

proc sql;
	select varname into: inputs separated by ' ' from varall;
	select count(*) into: nobs from varall;
quit;
	
%let nvar=%sysfunc(compress(&nobs));

ods html close;
ods output spearmancorr=spearman hoeffdingcorr=hoeffding;
proc corr data=&indata spearman hoeffding rank;
	var &inputs;
	with &target;
run;
ods html;

data spearman1(keep=variable scorr spvalue ranksp);
	length variable $ 80.;
	set spearman;
	array best(*) best1--best&nvar;
	array r(*) r1--r&nvar;
	array p(*) p1--p&nvar;
	do i=1 to dim(best);
		variable=best(i);
		scorr=r(i);
		spvalue=p(i);
		ranksp=i;
		output;
	end;
run;

data hoeffding1(keep=variable hcorr hpvalue rankho);
	length variable $ 80.;
	set hoeffding;
	array best(*) best1--best&nvar;
	array r(*) r1--r&nvar;
	array p(*) p1--p&nvar;
	do i=1 to dim(best);
		variable=best(i);
		hcorr=r(i);
		hpvalue=p(i);
		rankho=i;
		output;
	end;
run;

proc sort data=spearman1;
	by variable;
run;

proc sort data=hoeffding1;
	by variable;
run;

data correlations;
	merge spearman1 hoeffding1;
	by variable;
run;

proc sort data=correlations;
	by ranksp;
run;

proc print data=correlations width=min;
title "print of correlations";
run;

proc sql noprint;
	select min(ranksp) into: vref
	from (select ranksp
		from correlations 
		having spvalue > &pvalue);

	select min(rankho) into: href
	from (select rankho
		from correlations
		having hpvalue > &pvalue);
quit;

proc sgplot data=correlations;
	refline &vref / axis=y;
	refline &href / axis=x;
	scatter y=ranksp x=rankho / datalabel=variable;
	yaxis label="Rank of Spearman";
	xaxis label="Rank of Hoeffding";
	title "Scatter Plot of the Ranks of Spearman vs Hoeffding";
run;

proc sql;
	delete * from correlations
	where ranksp>&vref and rankho>&href;
quit;

%global screened;

proc sql;
	select trim(left(variable)) into: screened separated by ' ' from correlations;
quit;

%put &screened;

%mend;

libname dyps "/data02/temp/temp_hsong/product_banner";


%uniscreen(dyps.dyps_trainoversamp2, ./varfile.txt, action, .2);


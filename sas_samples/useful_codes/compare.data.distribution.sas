*** purpose: compare the distribution of two data sets: like data_jan vs data_feb ;
*** suppose all vars are normalized to be categorical. if originallly it is numeric, then manually cagegorize it;
*** old data and new data are combined together called forchisq, with timeframe=1 means old, timeframe=2 means new;

options MINOPERATOR; * enable to use 'in' operator in macro;

libname temp "/home/hsong/work/useful_codes/"; 

%let changed=0;

%macro chisq(vars, change_level_vars, timeframe);

data _null_;
	array a_var(*) &vars;
	call symput('nvar', ktrim(kleft(put(dim(a_var),8.))));
run;

%do i=1 %to &nvar;
	%let var=%scan(&vars, &i);
	
	%if &var in &change_level_vars %then %do;
		proc freq data=forchisq;
			tables &var * &timeframe / out=comp_&var (drop=percent);
		run;

		data comp_&var;
			merge comp_&var(in=in1 where=(&timeframe=1) rename=(count=old)) comp_&var(in=in2 where=(&timeframe=2) rename=(count=new)); 
			by &var;
			drop timeframe;
			if in1 and in2 then delete;
		run;

		proc sql;
			select count(*) into: changed from comp_&var;
		quit;

		%if &changed > 0 %then %do;
			proc printto file=toemail;
			run;
			title "New or deleted levels for &var";
			proc print data=comp_&var width=min;
			run;
			proc printto;
			run;
		%end;
	%end;

	%else %do;

		proc sql;
			select count(distinct &var) into: m_new_&var from forchisq where &timeframe=2;
			select count(distinct &var) into: m_old_&var from forchisq where &timeframe=1;
		quit;

		%if &&m_new_&var ne &&m_old_&var %then %do;
			%let changed=1;
			proc printto file=toemail;
			run;
			title "&var has different values of levels:";
			proc freq data=forchisq;
				tables &var * &timeframe / missing nocum nopercent;
			run;
			proc printto;
			run;
		%end;

		%else %do;
			proc freq data=forchisq(where=(&timeframe=1));
				tables &var / missing out=old_dist;
			run;

			proc sql;
				select percent into: percents separated by " " from old_dist;
			quit;

       			proc freq data=forchisq(where=(&timeframe=2));
				*weight &wt;
				table &var / missing chisq testp=(&percents);
				output out=chisq_&var(rename=(_PCHI_=Chisq P_PCHI=p_value)) chisq pchi;
			run;

			proc print data=chisq_&var width=min;
				title "Chisq values for &var";
			run;

			proc sql;
				select round(p_value, 0.001) into: pvalue from chisq_&var;
			quit;

			%if &pvalue<0.01 %then %do;
				%let changed=1;
				proc printto file=toemail;
				run;

				proc freq data=forchisq;
					title "&var distribution has changed.";
					table &var * &timeframe / missing norow nocum nopct;
				run;

				proc printto;
				run;
			%end;
		%end;
	%end;
%end;

%if &changed>0 %then %do;
	x cat toemail.lst | mail -s "Data distribution change report" &notify;
%end;

%mend chisq;


***  test the macro;
proc import datafile="/home/hsong/work/useful_codes/train.csv" out=forchisq(rename=(time=timeframe)) replace;
	getnames=yes;
run;
			
proc print data=forchisq width=min;
run;

%let vars=survived pclass sex sibsp parch embarked;

%let change_level_vars=cabin;

%let notify=hsong@nextag.com;

%chisq(&vars, &change_level_vars, timeframe);



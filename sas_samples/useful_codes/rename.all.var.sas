****** copied from internet  ******;

options macrogen mprint mlogic;

%macro rename(lib,dsn);

options pageno=1 nodate;

proc contents data=&lib..&dsn;
title "Before Renaming All Variables";
run;

proc sql noprint;
	select nvar into :num_vars
	from dictionary.tables
	where libname="&LIB" and memname="&DSN";
	
	select distinct(name) into :var1-:var%TRIM(%LEFT(&num_vars))
	from dictionary.columns
	where libname="&LIB" and memname="&DSN";
quit;
run;

proc datasets library=&LIB;
	modify &DSN;
	rename
	%do i=1 %to &num_vars;
		&&var&i=NEWNAME_&&var&i.
	%end;
;
quit;
run;

options pageno=1 nodate;

proc contents data=&lib..&dsn;
title "After Renaming All Variables";
run;

%mend rename;

data a;
x=1; 
y=2;
z=3;
u=4;
v=5;
run;

proc print data=a;
run;

%rename(WORK,a);

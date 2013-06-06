*********************************************************************************;
* This is an example to test the piecewise linear regression 			*;
* denote the cut off points as c1 c2 c3 ... cn               			*; 
* y = b0 + b1 * x + \sum_{i=1}^{n} b(i+1) * (x-ci) I(ci=<x)                     *;  
*********************************************************************************;

data test;
	do i=1 to 1000;
		x=1/1000*i*10*constant('Pi');
		y=cos(x);
		output;
	end;
run;

proc plot data=test;
	plot y * x;
run;

data xfmt(drop=i);
	fmtname="x_f";
	do i=0 to 9;
		start=i*constant("pi");
		end=(i+1)*constant("pi");
		label=end;
		output;
	end;
run;

proc print data=xfmt;
run;

proc format cntlin=xfmt;
run;

proc format lib=work cntlout=x_fmt;
	select x_f;
run;


proc print data=x_fmt;
run;

data fmt;
	set x_fmt(in=in1 keep=start rename=(start=label) )
	    x_fmt(in=in2 keep=end rename=(end=label) ) end=last;
	start=mod(_n_-1, 10)+1;
	end=start;
	if in1 then fmtname='x_lb';
	else fmtname='x_up';
	if last=1 then label='1000';
run;


proc print data=fmt;
run;

proc format cntlin=fmt;
run;

data test;
	set test;
	array a_x[10] x_g_1 - x_g_10;
	do i=1 to 10;
		if x > put(i, x_lb.) then a_x[i]=x-put(i, x_lb.);
		else a_x[i]=0;
	end;
run;

proc print data=test;
run;


proc reg data=test;
	model y = x_g_:;
	output out=reg_out p=yhat ;
run;

proc print data=reg_out(obs=10) width=min;
run;

proc plot data=reg_out;
	plot  yhat * x;
run;

data reg_out;
	attrib yhat label='';
	set reg_out;
run;

goptions reset=all border cback=white htitle=12pt htext=10pt;   
/* Define symbol characteristics */                                                                                                     
symbol1 interpol=spline value=point color=vibg width=.1;                                                                                           
symbol2 interpol=spline value=point color=depk width=.1; 
/* Define legend characteristics */                                                                                                     
legend1 order=('y' 'yhat') label=none frame; 
/* Define axis characteristics */                                                                                                       
axis1 label=none;                                                                                                                       
                   
proc gplot data=reg_out;
	plot (y yhat) * x / overlay legend=legend1 vaxis=axis1;
run;


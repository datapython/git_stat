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


proc sql;
        select col1 into :m_intercept from ests where lowcase(trim(left(_name_)))="intercept";
quit;

%put m_intercept=&m_intercept;

data temp_est;
        set ests;
        if _name_ = :"x_g_";
        x_g_n=substr(_name_,5)+0;
        x_lb=put(x_g_n, x_lb.);
        x_ub=put(x_g_n, x_ub.);
run;

proc print data=temp_est;
run;

proc sort data=temp_est;
        by x_g_n;
run;

data temp_est;
        set temp_est;
        retain new_intercept &m_intercept new_scope 0;
        new_scope + col1;
        new_intercept + (-x_lb * col1);
run;

proc print data=temp_est;
run;

** pick some data to double check they are the same **;
data double_check;
        set reg_out(keep=x y yhat);
        if 15.707963267949<x<18.8495559215388;
        yhat2=-13.3727+0.77394*x;
run;

proc print data=double_check;
run;






**** Do in R ****************  Do in R  ***************  Do in R  ***************;
N <- 40 # number of sampled points
K <- 5  # number of knots

piece.formula <- function(var.name, knots) {
   formula.sign <- rep(" - ", length(knots))
   formula.sign[knots < 0] <- " + "
       paste(var.name, "+",
               paste("I(pmax(", var.name, formula.sign, abs(knots), ", 0))",
	                     collapse = " + ", sep=""))
			     }

f <- function(x) {
    2 * sin(6 * x)
    }

set.seed(1)
x <- seq(-1, 1, len = N)
y <- f(x) + rnorm(length(x))

knots <- seq(min(x), max(x), len = K + 2)[-c(1, K + 2)]
model <- lm(formula(paste("y ~", piece.formula("x", knots))))

par(mar = c(4, 4, 1, 1))
plot(x, y)
lines(x, f(x))
new.x <- seq(min(x), max(x) ,len = 10000)
points(new.x, predict(model, newdata = data.frame(x = new.x)),
      col = "red", pch = ".")
points(knots, predict(model, newdata = data.frame(x = knots)),
       col = "red", pch = 18)





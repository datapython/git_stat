data a;
input a & $100.;
cards;
1.3.9
1.32.08
1.2.7
3.5.7.89
5
1.60.10
1.7
0.3
;
run;

proc print data=a;
run;

data b;
	set a;
	array a_split[*] a_1-a_20;
	do i=1 to dim(a_split);
		a_split[i]=scan(a,i,'.');
	end;
run;

data b;
	set b(drop=i);
	format _numeric_ z10.;
run;

proc sort data=b;
	by a_1--a_20;
run;

proc print data=b width=min;
run;


***  In R can use alike sprintf("%06d", data$anim) ***;
anim <- c(25499,25500,25501,25502,25503,25504)
sex  <- c(1,2,2,1,2,1)
wt   <- c(0.8,1.2,1.0,2.0,1.8,1.4)
data <- data.frame(anim,sex,wt)

data$anim <- sprintf("%06d", data$anim)

*** or use function formatC  ***;
formatC(anim, width = 6, format = "d", flag = "0") 
paste("0", anim, sep = "") 


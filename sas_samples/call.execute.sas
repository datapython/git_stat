data coef;
input coef1 coef2 coef3;
cards;
.1 .26 .58
;
run;

data test;
array a_iv{*} x1 x2 x3;
do j=1 to 100;
	do i=1 to 3;
		a_iv[i]=rand('normal',i);
	end;
	output;
end;
run;

data _null_;
	set coef end=last;
	if _n_=1 then call execute(' data score; set test; score=x1 * '|| coef1 || '+x2 * '|| coef2 || '+x3 * ' || coef3 || ';' );
run;

proc print data=score;
run;



***  if coef is in one column, we can store each into a macro variable, and then score use sas macro  ***;





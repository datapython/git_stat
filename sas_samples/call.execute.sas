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



***  use call execute to generate the score code  ***;

data _null_;
	set coef end=last;
	if _n_=1 then call execute(' data score(drop=i j); set test; key=_n_; score= 1 + x1 * '|| coef1 || '+x2 * '|| coef2 || '+x3 * ' || coef3 || ';' );
run;

proc print data=score;
run;




***  if coef is in one column, we can store each into a macro variable, and then score use sas macro  ***;

proc transpose data=coef out=coef1;
run;

proc print data=coef1;
run;

proc sql;
	select col1 into: m_coef1 through : m_coef3 from coef1;
quit;

%put &m_coef1 &m_coef2 &m_coef3;

data score2(keep=key score2);
	set test;
	key=_n_;
	score2=1+x1*&m_coef1 + x2*&m_coef2 + x3*&m_coef3;
run;


data merged;
	merge score score2;
	by key;
run;

proc print data=merged;
run;

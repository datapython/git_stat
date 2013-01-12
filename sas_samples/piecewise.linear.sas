data x;
do i=1 to 100;
	x=rand('normal',3,2);
	if x <= 0 then y=1 + 2*x + rand('normal',0,.1);
	else y=1 + -x  + rand('normal',0,.1);
	output;
end;
run;

data new;
	set x;
	if x<=0 then x1=0;
	else x1=1;
	xid1=x*x1;
run;

proc reg data=new;
	model y=x  xid1;
run;



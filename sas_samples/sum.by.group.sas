%let m_n=5;

data a;
  do id=1 to 10;
    do j=1 to rand('poisson',&m_n);
      x=rand('normal',1,1);
      output;
    end;
  end;
run;

proc print data=a;
run;

proc sort data=a(drop=j);
  by id x;
run;


data s1;
	set a;
	by id;
	if first.id then do;
		new=0;
		xsum=0;
	end;
	new+1;
	xsum+x;
	if last.id then do;
		output;
	end;
run;

proc print data=s1;
run;

proc sql;
	select sum(x) as sumx 
	from a
	group by id;
quit;


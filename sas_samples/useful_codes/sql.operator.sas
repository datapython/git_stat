data a;
input id val $10.;
cards;
1 one
1 two 
1 three
1 one
1 one
1 one
1 two
2 two
2 three
3 three
;
run;


data b;
input id val2 $10.;
cards;
1 one
1 two
2 one
2 two
;
run;


proc sql;
create table exceptall as
select * from a
except all 
select * from b;
quit;

proc print data=exceptall width=min;
run;

proc sql;
create table outerunion as
select * from a
outer union corr 
select * from b;
quit;

proc print data=outerunion width=min;
run;

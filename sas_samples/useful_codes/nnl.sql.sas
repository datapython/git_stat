** list the pair of node that a customer visited;

data a;
input id node $2.;
cards;
1 a
1 b
1 c
2 a
2 b
3 e
3 f
5 m
;
run;


proc sql;
	create table t as
	select a1.*, a2.node as node2
	from a as a1 left join a as a2
	on a1.id=a2.id;
quit;

proc print data=t;
run;


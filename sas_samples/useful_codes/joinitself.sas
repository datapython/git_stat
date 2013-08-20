data m;
input id dir $2.;
cards;
1 a
2 b
2 c
3 d
4 b
4 c 
5 a
5 b
5 c
6 b
6 e
7 d
7 e
;
run;


proc sql;
create table t1 as
select distinct m1.id as id1, m2.id as id2 
from m as m1 left join m as m2
on m1.dir=m2.dir and m1.id ^= m2.id
group by m1.dir
order by id1, id2;
quit;

proc print data=m;
proc print data=t1;
run;

proc sql;
create table tfinal as
select id1, count(*) as cnts
from 
(select distinct m1.id as id1, m2.id as id2
from m as m1 left join m as m2
on m1.dir=m2.dir and m1.id ^= m2.id
group by m1.dir
)
group by id1;
quit;

proc print data=tfinal;
run;

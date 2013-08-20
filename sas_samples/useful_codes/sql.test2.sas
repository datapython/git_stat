data table1;
input x $2. parent $2.;
cards;
a b
b c
c d
d e
e f
f g 
h i
i j
j k
k l
l m
m n
o p
p q
q s
;
run;

data table2;
	set table1;
run;

%macro looop;

%do i=1 %to 10;

	proc sql;
		create table table2 as
		select t2.*, t1.parent as parpar
		from table2 as t2 left join table1 as t1
		on t2.parent=t1.x
		order by t2.x;
	quit;

	data table2;
		set table2(rename=(parent=par&i parpar=parent));
	run;

	proc print data=table2 width=min;
		title "print of table2 &i";
	run;
%end;

%mend looop;



%looop;





endsas;


/*
proc sql;
	select *
	from table1 as x left join table1 as y 
	on x.col2=y.col1
	left join table1 as z
	on y.col2=z.col1;
quit;


endsas;
*/

proc sql;
SELECT
x.col1 AS col1,
CASE
WHEN z.col2 IS NULL AND y.col2 IS NULL THEN x.col2
WHEN z.col2 IS NULL AND y.col2 IS NOT NULL THEN y.col2
ELSE z.col2
END AS col2
FROM
table1 AS x
LEFT JOIN table1 AS y
ON
x.col2 = y.col1
LEFT JOIN table1 AS z
ON
y.col2 = z.col1
order by col1;
;
quit;

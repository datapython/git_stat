data table1;
input col1 $2. col2 $2.;
cards;
a b
b c
c d
e f
f g
;
run;


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

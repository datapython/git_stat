data a;
input a b c d e f g h i j k l m n o p q;
cards;
1 2 3 4 5 6 7 1 2 3 4 5 6 7 1 2 3
;
run;

proc contents data=a out=varnames;
run;

proc print data=varnames;
run;

filename pre "./pre.txt";

data _null_;
	file pre;
        set varnames end=eof;
	if _n_=1 then put "rename ";
        newvarname=trim(name)||'pre';
        put name '= ' newvarname;
	if eof then put ';';
run;

data b;
        set a;
        %include pre;
run;

proc print data=b;
run;


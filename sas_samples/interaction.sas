data test;
	do i=1 to 3;
		do j=1 to 5;
			do s=1 to 50;
				x=rand('normal',0,1);
				output;
			end;
		end;
	end;
run;

proc print data=test;
run;

**  mean value at each cell combination ;
proc means data=test;
	class i j;
	var x;
run;

** here the diff between cells are fixed, there is restriction ;
proc glm data=test;
	class i j;
	model x= i j / solution;
	output out=reg1;
run;

** here the diff between cells are free to change ;
** you will find intercept will equal to one of the value from proc means, the coeffecient is the diff of the cells from proc means ;
proc glm data=test;
        class i j;
        model x= i | j / solution;
	output out=reg2;
run;



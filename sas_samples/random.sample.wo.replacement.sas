*** the purpose is to sample 200 records from the data population;

%macro samp_wo_rep(population, sampsize);
data sample(drop=i j count);
	count=0;
	array obsnum(&sampsize) _temporary_;
	do i=1 to &sampsize;
		redo:
		select=ceil(ranuni(12345)*n);
		put "the value of n is: " n;
		put "The value of select is: " select;
		set &population point=select nobs=n;
		do j=1 to count;
			if obsnum(j)=select then goto redo;
		end;
		count=count+1;
		put "The value of count is: " count;
		obsnum(count)=select;
		output;
	end;
	STOP;
run;
%mend samp_wo_rep;

%samp_wo_rep(testdata, 200);






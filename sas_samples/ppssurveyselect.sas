***  when use pps in proc surveyselect, there is the limitation of maximum sample size (say 1000) every time. If your wanted sample size (say 3000) ***;
***  is greater than this max available sample size, it will show error message. One way to solve this is to sample several times (3 times) with    ***;
***  each time to sample the max available sample size. That is, sample 3 times without replacement with each time 1000 samples                     ***;

%macro ppssample(dataname, m_tot_sample_size, sizevar);
	proc sql;
		select floor(sum(&sizevar)/max(&sizevar)) into: m_max_sample_size from &dataname;
	quit;

	data _null_;
        	pps_loop=ceil(&m_tot_sample_size/&m_max_sample_size);
        	pps_each_size=ceil(&m_tot_sample_size/pps_loop);
        	call symput('pps_loop',pps_loop);
        	call symput('pps_each_size', pps_each_size);
	run;
	
	%put m_max_sample_size=&m_max_sample_size;

	data first_sample;
		set &dataname;
	run;

	%if &pps_loop>1 %then %do;
	
		%do i=1 %to &pps_loop;

			proc surveyselect data=first_sample  method=pps sampsize=&pps_each_size
				out=pps_sample_&i. seed=-1;
				size &sizevar;
			run;
			title "to compare: first_sample";
			proc contents data=first_sample;
			run;
			title "to coampare: pps_sample_&i.";
			proc contents data=pps_sample_&i.;
			run;
				
			proc sql;
				create table first_sample as
				select * from first_sample
				EXCEPT CORR
				select * from pps_sample_&i.(drop=samplingweight SelectionProb);
			quit;

                        title "contents of first_sample for loop &i";
                        proc contents data=first_sample;
                        run;

			data pps_sample;
				%if &i=1 %then %do;
					set pps_sample_1; 
				%end;
				%else %do;
					set pps_sample pps_sample_&i.; 
				%end;
			run;
                %end;

        %end;

        %else %do;

                proc surveyselect data=first_sample method=pps sampsize=&m_tot_sample_size out=pps_sample seed=-1;
			size &sizevar;
		run;

        %end;

	proc surveyselect data=pps_sample method=srs n=&m_tot_sample_size out=final;
	run;

%mend ppssample;

%ppssample(prep,5000,revenue);






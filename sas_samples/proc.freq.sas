******  proc freq   different of MISSING  ******;

data one;
   input A Freq;
      datalines;
      1 2
      2 2
      . 2
      ;
run;


proc freq data=one;
   tables A;
      weight Freq;
         title 'Default';
	 run;


proc freq data=one;
   tables A / missprint;
      weight Freq;
         title 'MISSPRINT Option';
	 run;


proc freq data=one;
   tables A / missing;
      weight Freq;
         title 'MISSING Option';
	 run;


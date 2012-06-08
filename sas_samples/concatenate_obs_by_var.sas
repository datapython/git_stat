***  The purpose is to concatenate all obs of var b c together separated by : and group by var a   ***;
***  That is, the result is like a:a:b:b:c:c  d:d:e:e:f:f                                          ***;

data a;
   input a b $ c $;
     cards;
     1 a a
     1 b b
     1 c c
     2 d d
     2 e e
     2 f f
     ;
run;
 

data test;
	  set a;
	    retain concat;
	      by a b;
	        if first.a then concat=catx(":",b,c);
		  else concat=catx(":",catx(":",concat,b),trim(left(c)));
		    if last.a then output;
run;

 
proc print data=test;
run;

** example from http://philihp.com/blog/2009/converting-a-date-to-a-datetime-in-sas/ ;

data _null_;
  d='29FEB1984'd;
    put d date.;
      dt=d*24*60*60;
        put dt datetime.;
	  d=dt/24/60/60;
	    put d date.;
	    run;


data _null_;
   d='29FEB1984'd;
     put d date.;
       dt=input(put( d  ,date7.) || ':00:00:00', datetime.);
         put dt datetime.;
	   d =input(substr(put(dt,datetime.),1,7),date7.);
	     put d date.;
	     run;


data _null_;
  d='29FEB1984'd;
    put d date.;
      dt=dhms(d,0,0,0);
        put dt datetime.;
	  d =datepart(dt);
	    put d date.;
	    run;

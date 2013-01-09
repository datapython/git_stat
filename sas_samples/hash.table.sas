*** study hash table by examples: http://www2.sas.com/proceedings/forum2008/029-2008.pdf  ***;

*** example 1:  ***;
data plans;
input Plan_id $1-3 Plan_desc $;
cards;
XYZ HMO Salaried
ABC PPO Hourly
JKL HMO Executive
;
run;

data members;
input Member_id $ Plan_id $;
cards;
164-234 XYZ
297-123 ABC
344-123 JKL
395-123 XYZ
495-987 ABC
562-987 ABC
697-123 XYZ
833-144 JKL
987-123 ABC
;
run;

data both(drop=rc);
	declare hash plan ();
		
		rc=plan.DefineKey ("plan_id");
		rc=plan.DefineData ("plan_desc");
		rc=plan.DefineDone ();

		do until (eof1);
			set plans end=eof1;
			rc=plan.add ();
		end;

		do until (eof2);
			set members end=eof2;
			call missing(plan_desc);
			rc=plan.find ();
			output;
		end;

	stop;
run;

proc print data=both;
run;

	

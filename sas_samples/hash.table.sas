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

	
***  example 2A:  ***;
data members;
input Member_id $ 1-7 Plan_id $9-11 Group_id $ 13-16;
cards;
164-234 XYZ G123
297-123 ABC G123
344-123 JKL G456
395-123 XYZ G123
495-987 ABC G456
562-987 ABC G123
697-123 XYZ G456
;
run;

data groups;
input Group_id $4. Group_name $ 5-20;
cards;
G456 Toy Company
G123 Umbrellas, Inc.
;
run;

data triple(drop=rc);
	declare hash plan ();
	declare hash group ();

	rc=plan.DefineKey ("plan_id");
	rc=plan.DefineData ("plan_desc");
	rc=plan.DefineDone ();

	rc=group.DefineKey ("group_id");
	rc=group.DefineData ("group_name");
	rc=group.DefineDone ();

	do until (eof1);
		set plans end=eof1;
		rc=plan.add ();
	end;

	do until (eof2);
		set groups end=eof2;
		rc=group.add ();    *** made a mistake here by input plan.add at the first time, then there is no group_name output;
	end;

	do until (eof3);
		set members end=eof3;
		call missing (plan_desc);
		rc=plan.find ();
		call missing (group_name);
		rc=group.find ();
		output;
	end;

	stop;
run;

proc print data=triple;
run;


***  example 2B:  JOIN ON 2 LEVELS OF SPECIFICITY  ***;
data members;
input zip $ Member_id $;
cards;
04021 164-234
22003-1234 297-123
45459-0306 344-123
03755 395-123
94305 495-987
78277-8310 562-987
88044-3760 697-123
;
run;

data zip;
input zip $5. income $10.;
cards;
04021 $45,000
22003 $56,000
03755 $75,000
45459 $72,000
94305 $96,000
78277 $32,000
88044 $47,000
;
run;

data Zip_plus_4;
input zip $10. income $10.;
cards;
04021-0306 $45,999
22003-1234 $56,999
45459-0306 $72,999
03755-1234 $75,999
94305-1234 $96,999
78277-8310 $32,999
88044-3760 $47,999
;
run;

data member_income(drop=rc);

	declare hash zip5 (dataset: "zip");
	rc=zip5.DefineKey ("zip");
	rc=zip5.DefineData ("income");
	rc=zip5.DefineDone ();

	declare hash zip9 (dataset: "zip_plus_4");
	rc=zip9.DefineKey ("zip");
	rc=zip9.DefineData ("income");
	rc=zip9.DefineDone ();

	do until (eof3);
		set members end=eof3;
		income=.;
		rc=zip9.find ();
		if rc ne 0 then 
		rc=zip5.find ();
		output;
	end;

	stop;
run;

proc print data=member_income;
run;


***  example 3:  ***;
data claims;
input member_id $ svc_dt $10. dx;
cards;
164-234 2005/01/01 250
297-123 2005/02/03 4952
164-234 2005/03/15 78910
297-123 2005/04/14 250
297-123 2005/08/19 12345
164-234 2005/09/13 250
297-123 2005/11/01 4952
;
run;

data processed_claims (drop=rc);

	length latest_dt $10.;

	declare hash members (ordered: "a");  *** "a" means asending order;

	rc=members.DefineKey ("member_id");
	rc=members.DefineData ("member_id", "latest_dt");
	rc=members.DefineDone ();
	
	do until (eof);
		set claims end=eof;
		latest_dt="";
		rc=member.find ();
		if rc=0 then do;
			seen_it="YES";
		end;
		else do;
			seen_it="NO";
		end;
		latest_dt=svc_dt;
		members.replace ();
		output;
	end;

	members.output (dataset: "members_latest");

	stop;
run;

proc print data=claims;
run;

proc print data=members_latest;
run;


***  example 4: CHAIN (UNLIMITED RECURSIVE LOOKUPS) ***;








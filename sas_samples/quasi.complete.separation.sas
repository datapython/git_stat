***  see ~\SkyDrive\Dropbox\data\fansnap\qsc01.docx and qsc01.csv  ***;

data qcs;
input pid cid deals;
cards;
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 1 0
550 2 0
550 2 0
550 1 0
550 1 0
550 2 0
550 1 0
550 1 0
550 1 0
550 3 0
550 3 0
550 3 0
550 3 0
550 3 0
550 2 0
550 2 0
550 2 0
550 2 0
550 1 0
550 1 0
550 2 0
550 2 0
550 2 0
630 2 0
630 2 0
630 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 1 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 1 0
630 2 0
550 2 0
550 2 0
550 2 0
550 2 0
630 3 0
630 3 0
630 3 0
630 3 0
630 3 0
630 3 0
630 2 0
550 2 0
550 2 0
550 2 0
550 2 0
550 3 0
630 3 0
630 1 0
630 1 0
630 1 0
630 2 0
630 2 0
630 2 0
630 2 0
630 2 0
630 2 0
630 2 0
630 2 0
550 2 1
550 2 1
550 3 1
550 2 1
550 2 1
550 2 1
630 1 1
630 2 1
;
run;

title "tabulate separately";
proc tabulate data=qcs;
	class pid cid deals;
	table pid cid, deals;
run;

title "tabulate of combination";
proc tabulate data=qcs;
        class pid cid deals;
        table pid * cid, deals;
run;

proc logistic data=qcs;
	class pid cid;
	model deals(event="1")=pid cid;
run;

proc logistic data=qcs;
        class pid cid;
        model deals(event="1")=pid | cid ;
run;


proc logistic data=qcs;
        class pid cid;
        model deals(event="1")=pid | cid / firth;
run;


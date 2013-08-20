*** find: find the starting position where the string is;
*** findc: find the starting position there any char of the string is;
*** findw: find the position where the string is, the string must be separeted by blank or sth else;

data a;
a="this place is where her bag is";
run;


data b;
set a;
f=find(a, 'is');
fc=findc(a, 'is');
fw=findw(a, 'is');
f2=find(a, 'ag');
fc2=findc(a, 'ag');
fw2=findw(a, 'ag');
f3=find(a, 'isa');
run;


proc print data=b;
run;

endsas;





libname temp "/data02/temp/temp_hsong/to_delete/temp";

&m_l_tdb1;

/*
data temp.vn;
set tdb1.visitnew(where=("08aug2013:10:00:00"dt<=start_time<="08aug2013:12:00:00"dt) keep=visit_id publisher_id visit_details CLICK_COUNT CLICK_REVENUE start_time);
p1=find(visit_details, 'gg_adpos');
p2=findw(visit_details, 'gg_adpos');
p3=findc(visit_details, 'gg_adpos');	
p12=p1-p2;
p13=p1-p3;
p23=p2-p3;
if p1>0;
run;


proc freq data=temp.vn;
	table p12 p13 p23 / missing list;
run;

*/

proc print data=temp.vn(obs=100) width=min;
var p1 p2 p3 p12 p13 p23;
run;

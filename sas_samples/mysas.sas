***  it's better to write all tips in one file so that easy to search through  ***;


******  9:     ******;


******  8:     ******;


******  7:     ******;


******  6:     ******;


******  5:     ******;


******  4:     ******;


******  3:     ******;


******  2: how to macros in catalog    ******;
proc catalog catalog=LIBNAME.sasmacr;
	contents;
run;


******  1: how to call R function in sas  ******;
*** http://support.sas.com/documentation/cdl/en/imlug/64248/HTML/default/viewer.htm#r_toc.htm  ***;

proc options option=RLANG;
run;

proc iml;
use Sashelp.Class;
read all var {Weight Height};
close Sashelp.Class;


******  2: how to obtain percentiles not automatically calcuated in SAS   ******;
***  http://www.ats.ucla.edu/stat/sas/faq/percentiles.htm    ***;

proc univariate data=hsb noprint;
   var math science;
   output out=percentiles2 pctlpts=33 45 pctlpre=math science;
run;

proc print data=percentiles2;
run;


******  3:       *******;






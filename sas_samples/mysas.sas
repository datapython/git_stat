***  it's better to write all tips in one file so that easy to search through  ***;


******  9:     ******;


******  8:     ******;


******  7:     ******;


******  6:     ******;


******  5:     ******;


******  4:     ******;


******  3:     ******;


******  2:     ******;



******  1: how to call R function in sas  ******;
*** http://support.sas.com/documentation/cdl/en/imlug/64248/HTML/default/viewer.htm#r_toc.htm  ***;

proc options option=RLANG;
run;

proc iml;
use Sashelp.Class;
read all var {Weight Height};
close Sashelp.Class;



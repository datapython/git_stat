***  it's better to write all tips in one file so that easy to search through  ***;


******  9:     ******;


******  8:     ******;


******  7:     ******;


******  6:     ******;


******  5:     ******;


******  4: SAS operators    ******;
http://support.sas.com/documentation/cdl/en/lrcon/62955/HTML/default/viewer.htm#a000780367.htm
some of it: in and or || : ,  'fox'='fox ' but 'fox' ^= ' fox'(trailing blanks are ignored, leading blanks are not)
another:  server in :("lu" "lm" "dl" "sdlu")


******  3: how to create index in SAS    ******;
Index
1: yield faster access to small subsets of obs for WHERE processing
2: return obs in sorted order for BY processing
3: perform table lookup operations
4: join obs
5: modify obs

Simple index:  (index=(myindex))  or (index=(lastname firstname))
Composite index:  (index=(comp_index=(lastname firstname)));

Pcoc datasets library=libref;
	Modify sas_data_set;
	Index delete index_name;
	Index create index_specification;
Quit;

Proc sql;
	Create index index_name on table_name;
	Drop index index_name from table_name;
Quit;

Task	                              						 Effect
Add observation(s) to data set	                                Value/identifier pairs are added to index(es).
Delete observation(s) from data set				Value/identifier pairs are deleted from index(es).
Update observation(s) in data set				Value/identifier pairs are updated in index(es).
Delete data set							The index file is deleted.
Rebuild data set with DATA step					The index file is deleted.
Sort the data in place with the FORCE option in PROC SORT	The index file is deleted.



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






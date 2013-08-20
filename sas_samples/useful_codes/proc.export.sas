** per request by sanjay ;

&m_l_sasbi;
libname temp "/data02/temp/temp_hsong/to_delete";

proc datasets lib=sasbi;
run;

/*
proc sql;
	create table temp.OUTPDIR_IMP_SAMPLE as
	select * from sasbi.OUTPDIR_IMP_SAMPLE 
	where imp_date >= "01jul2013:00:00:00"dt and imp_date < "02jul2013:00:00:00"dt;
quit;



proc sql;
        create table temp.OUTPDIR_IMP_PTITLE_SAMPLE  as
        select * from sasbi.OUTPDIR_IMP_PTITLE_SAMPLE 
        where imp_date >= "01jul2013:00:00:00"dt and imp_date < "02jul2013:00:00:00"dt;
quit;



proc sql;
        create table temp.OUTPDIR_IMP_SELLER_SAMPLE   as
        select * from sasbi.OUTPDIR_IMP_SELLER_SAMPLE 
        where imp_date >= "01jul2013:00:00:00"dt and imp_date < "02jul2013:00:00:00"dt;
quit;
*/


PROC EXPORT DATA=temp.OUTPDIR_IMP_SAMPLE
            OUTFILE='/data02/temp/temp_hsong/adhoc/OUTPDIR_IMP_SAMPLE.csv'
            DBMS=DLM REPLACE;
     DELIMITER='09'x;
     PUTNAMES=yes;
RUN;

PROC EXPORT DATA=temp.OUTPDIR_IMP_PTITLE_SAMPLE
            OUTFILE='/data02/temp/temp_hsong/adhoc/OUTPDIR_IMP_PTITLE_SAMPLE.csv'
            DBMS=DLM REPLACE;
     DELIMITER='09'x;
     PUTNAMES=yes;
RUN;


PROC EXPORT DATA=temp.OUTPDIR_IMP_SELLER_SAMPLE
            OUTFILE='/data02/temp/temp_hsong/adhoc/OUTPDIR_IMP_SELLER_SAMPLE.csv'
            DBMS=DLM REPLACE;
     DELIMITER='09'x;
     PUTNAMES=yes;
RUN;


endsas;


*****************  proc import  ******************************;
PROC IMPORT OUT=WORK.TEST
            FILE="/data02/temp/temp_hsong/adhoc/OUTPDIR_IMP_SAMPLE.csv"
            DBMS=TAB REPLACE;
    GETNAMES=YES;
    DATAROW=2;
RUN;

proc print data=test(obs=20) width=min;
run;

endsas;












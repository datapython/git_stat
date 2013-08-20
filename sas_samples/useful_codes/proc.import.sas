&m_l_sasbi;
libname temp "/data02/temp/temp_hsong/to_delete";


PROC IMPORT OUT=WORK.TEST
            FILE="/data02/temp/temp_hsong/adhoc/OUTPDIR_IMP_SAMPLE.csv"
            DBMS=TAB REPLACE;
    *GETNAMES=YES;
    *DATAROW=2;
RUN;

proc print data=test(obs=20) width=min;
run;

endsas;


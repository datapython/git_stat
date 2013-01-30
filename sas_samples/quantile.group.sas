** purpose: to group the variables by quantiles, so that each group has similar number of obs  ;
** diff from use proc rank(bucket) to group vars, in which group by equal space from min to max ;


%macro quant(indata, contvar, byn);
proc univariate data=&indata(where=(indicator=2));
        var &contvar;
        **logrpv logcnt product_cnt TOP_TITLE_TAG_COUNT google_search_count;
        output out=percentiles pctlpts=0 to 100 by &byn pctlpre=p;
run;

proc transpose data=percentiles out=t_percentiles(rename=(_name_=pct_name col1=&contvar._percentiles));
run;

proc print data=t_percentiles width=min;
run;

proc sort data=t_percentiles nodupkey;
        by &contvar._percentiles;
run;

data &contvar._fmt;
        set t_percentiles end=last;
        fmtname="&contvar._fmt";
        start=lag(&contvar._percentiles);
        end=&contvar._percentiles;
        label=pct_name;
        output;
        if last then do;
                hlo="O";
                label=.;
                output;
        end;
run;

data &contvar._fmt;
        set &contvar._fmt;
        if _n_>1;
run;

proc print data=&contvar._fmt;
run;

proc format cntlin=&contvar._fmt;
run;

%mend quant;

%quant(temp1, google_search_count, 10);


***  usage: sas seo.kws.expr.samp.sasjsp.sas -sysparm '99 01may2012 14may2012 yes all 10000/10000/10000 8b hsong@abc.com' &   ***;
 
**************** This is to use visitnew table rather than rpt_pub_rpv_phrase table to prepare for samples   *************;

* select kws for SEO experiment;
*03jun2011: exclude wize nodes (34) to sample kws for new expr. in_wize_node=0;

&m_l_oracle_s;
Options fmtsearch=(oracle_s);

&m_l_tdb1;
&m_l_oracle_s;

/***
%let expr_no=13;
%let d=11MAY2012;
%let gg_only=yes;
%let category=no;
%let s_stdt=01MAY2012;
%let s_eddt=14MAY2012;
%let catid=3;
***/

%let rpvlvlist=125314712 121990226 129882275;


libname seo '/data02/temp/temp_sasprod/seo/kws_for_seo';
libname seo_expr "/data02/temp/temp_sasprod/seo/seo_expr";

data a;
	array parms{*} $1000 w1 w2 w3 w4 w5 w6 w7 w8;
	length delim $1 x $1000;
	delim=' ';
	x=symget('sysparm');
	x=trim(x);
	x=compbl(x);
	wrdcount = length(x) - length(compress(x)) + 1;
	do i=1 to wrdcount;
		parms(i)=scan(x,i,delim);
		parms(i)=translate(parms(i),' ','/');
		call symput('parm'||put(i,Z2.),trim(parms(i)));
	end;
	   ***  expr_no=w1;
	   ***  s_stdt=w2;
	   ***  s_eddt=w3;
	   ***  gg_only=w4;  *** yes gg, no non-gg, all all **;
	   ***  catid=w5;
	   ***  size_each_group=w6;
	   ***  exclude_expr_no=w7;
	call symput('expr_no',trim(left(w1)));
	call symput('s_stdt',trim(left(w2)));
	call symput('s_eddt',trim(left(w3)));
	call symput('gg_only',trim(left(w4)));
	call symput('catid',trim(left(w5)));
	call symput('size_each_group',trim(left(w6)));
	call symput('exclude_expr_no',trim(left(w7)));
	call symput('notify',trim(left(w8)));
run;

data b;
        attr_date0=intnx('WEEK',"&s_eddt"d,-1,'E');
        attr_date=attr_date0-1;
        call symput('attr_date',trim(left(put(attr_date,date9.))));
run;

***  extract group and group size info  ***;
data group_num(keep=sample_size);
	a="&size_each_group";
	a=trim(a);
	a=compbl(a);
	delim=' ';
	wrdcount_a=length(a)-length(compress(a))+1;
	do i=1 to wrdcount_a;
		sample_size_char=scan(a,i,delim);
		sample_size=sample_size_char + 0;
		output;
	end;
run;

proc print data=group_num width=min;
run;

proc sql;
	select count(1) into: m_group_n from group_num;
	select sum(sample_size) into : m_tot_sample_size from group_num;
quit;

data _null_;
	set group_num;
	call symput ('ssize'||trim(left(_n_)),trim(left(sample_size)));
	call symput ('numsample',trim(left(_n_)));
run;

***  extract exclude expr num info  ***;
data exclude_old_expr(keep=exclude_no exclude_expr);
	a="&exclude_expr_no.";
        a=trim(a);
        a=compbl(a);
        delim=' ';
        wrdcount_a=length(a)-length(compress(a))+1;
        do i=1 to wrdcount_a;
		exclude_no=scan(a,i,delim);
		exclude_expr='seo_expr.seo_expr'||trim(left(exclude_no))||'(keep=phrase)';
		output;
	end;
run;

proc print data=exclude_old_expr width=min;
run;
	
proc sql;
	select exclude_expr into: m_exclude_old separated by ' ' from exclude_old_expr;
run;

%put &expr_no &s_stdt &s_eddt &gg_only &catid &size_each_group &m_tot_sample_size &exclude_expr_no &attr_date &m_exclude_old ;


***  pick only SEO and US market publishers, sometimes it may restrict to only google  ***;
%macro pub_id;

  data pub;
     set oracle_s.publisher_info(where=(traffic_type_name='organic search' and market_name='US'
        %if &gg_only=yes %then %do; and pub_group_id=410 %end; %else %if &gg_only=no %then %do; and pub_group_id ^= 410 %end;)
            keep=market_name traffic_type_name publisher_id publisher_name pub_group_name pub_group_id);
     run;
 
   %global seo_pubs;

   proc sql;
     select distinct publisher_id into :seo_pubs separated by ' ' from pub;
   quit;

%mend pub_id;

%pub_id;

***  get visits revenue clicks fot the seo kws from visitnew table  ***;

%macro visitnew(type, stdt, eddt);  

 	***  select category_id if necessary  ***;
        data cid;
                set tdb1.phrase_category(keep=category_id category_name);
                retain fmtname '$cid' type 'C';
                start=category_name;
                end=category_name;
                label=category_id;
                hlo=' ';
        run;

        proc sql;
                insert into cid (fmtname, type,  hlo, label)
                values ('$cid', 'C', 'O', 999999);
        quit;

        proc print data=cid width=min;
        run;

        proc format cntlin=cid;
        run;

	***  readin data from saved visitnew table  ***;

        data visitnew(index=(phrase));
                set seo_expr.seo_visitnew_raw(where=("&stdt"d <= report_date <= "&eddt"d and publisher_id in (&seo_pubs)));
   		  length category top_node $50.;
   		  top_node=put(ad_node_id, node2top.);
   		  category=scan(top_node,1,'/');
   		  if category not in ("Clothing & Accessories", "Home & Garden", "Non-Tech Other", "Tech") then category="Others";
   		  category_id=put(category, $cid.)+0;
        run;

	%global m_tot_visitnew_revenue;
	proc sql;
		select sum(revenue) into: m_tot_visitnew_revenue from visitnew ;
	quit;

        title "print of visitnew table: original";
        proc print data=visitnew(obs=100) width=min;
        run;

	proc freq data=visitnew;
		tables category_id / missing list;
	run;
	
	title "print of visitnew table: with top_node";
	proc print data=visitnew(obs=100) width=min;
	run;

	%if &catid ^= all %then %do;
   		%let catid=%eval(&catid+0);
	%end;

	data track;
	     set visitnew(keep=report_date phrase revenue clicks category_id %if &catid ^= all %then where=(category_id=&catid););
	     visits=1;
	run;

	proc freq data=track;
		tables category_id / missing list;
	run;


	proc sort data=track;
		by phrase category_id;
	run;

	proc sql;
		create table check_track as
		select phrase, count(distinct category_id) as num_diff_cat
		from track
		group by phrase
		order by num_diff_cat;
	quit;
		
	title "print of check_track";
	proc print data=check_track width=min;
	run;

	title "check one phrase has different category_id";
	proc print data=track(obs=1000) width=min;
	run;

   proc summary data=track nway;
     class phrase;
     id category_id;
     var visits revenue clicks;
     output out=kws_seo_expr_&expr_no.(drop=_type_ _freq_) sum=;
   run;

	title "check category after proc summary for phrase in visitnew table";
	proc freq data=kws_seo_expr_&expr_no.;
		tables category_id / missing list;
	run;

   proc sort data=seo.seo_kws_attr_&attr_date(keep=phrase category_id phrase_id keyword_id rename=(category_id=attr_cid))  out=seo_kws_attr nodupkey;
     by phrase;
   run;

   data seo_expr.kws_seo_expr_poll_&expr_no.;
     merge kws_seo_expr_&expr_no.(in=in1) seo_kws_attr(in=in2);
     by phrase;
     if in1 and in2;
     if revenue<0 then revenue=0;
     if visits<0 then visits=0;
     if clicks<0 then clicks=0;
     if phrase_id in (&rpvlvlist) then delete;
   run;

%mend visitnew;

%visitnew(sample, &s_stdt, &s_eddt);

proc freq data=seo_expr.kws_seo_expr_poll_&expr_no.;
	tables category_id*attr_cid / missing list;
run;



**************************   Sampling Part  ************************;

data to_exclude;
	set &m_exclude_old;
run;

proc sort data=to_exclude nodupkey;
	by phrase;
run;

data kws_seo_expr_poll_&expr_no.;
        set seo_expr.kws_seo_expr_poll_&expr_no.;
run;

proc sort data=kws_seo_expr_poll_&expr_no.;
        by phrase;
run;

data kws_seo_expr_poll_&expr_no.;
        merge kws_seo_expr_poll_&expr_no.(in=in1)  to_exclude(in=in2);
        if in1 and not in2;
run;

proc univariate data=kws_seo_expr_poll_&expr_no.;
	var visits;
	output out=visitsinfo median=median q3=q3 p90=p90 p95=p95 p99=p99 max=max;
run;

proc univariate data=kws_seo_expr_poll_&expr_no.;
        var revenue;
        output out=revenueinfo median=median q3=q3 p90=p90 p95=p95 p99=p99 max=max;
run;

proc sql;
	select median into: m_vis_low from visitsinfo;
	select p95 into : m_vis_high from visitsinfo;
	select median into: m_rev_low from revenueinfo;
	select p95 into : m_reg_high from revenueinfo;
quit;

data kws_seo_expr_poll_&expr_no.;
	set kws_seo_expr_poll_&expr_no.;
	where &m_vis_low<=visits<=&m_vis_high and &m_rev_low<=revenue<=&m_reg_high;
run;

proc sql;
        select floor(sum(visits)/max(visits)) into :m_max_sample_size
        from kws_seo_expr_poll_&expr_no.;
run;

data _null_;
	pps_loop=ceil(&m_tot_sample_size/&m_max_sample_size);
	pps_each_size=ceil(&m_tot_sample_size/pps_loop);
	call symput('pps_loop',pps_loop);
	call symput('pps_each_size', pps_each_size);
run;
	
%put pps_each_size=&pps_each_size pps_loop=&pps_loop;

***  First use pps to pick data   ***;

%macro ppssample;

	data first_sample;
		set kws_seo_expr_poll_&expr_no.;
	run;

	%if &pps_loop>1 %then %do;

		*** This may cause a little more sample, so need to pick &m_tot_sample_size samples  ***;

		%do i=1 %to &pps_loop;
			proc surveyselect data=first_sample %if &i>1 %then %do; (where=(group<1))%end;  method=pps sampsize=&pps_each_size 
				out=pps_sample_&i.(keep=phrase) seed=-1;
				size visits;
			run;
			
			proc sort data=first_sample;
				by phrase;
			run;
	
			proc sort data=pps_sample_&i;
				by phrase;
			run;
	
			data first_sample;
				merge first_sample pps_sample_&i(in=in2);
				by phrase;
				if in2 then group=&i;
			run;
		%end;

		data pps_sample(drop=group);
			set first_sample;
			where group ^=.;
		run;

		proc contents data=pps_sample;
		run;

	%end;

	%else %do;
		proc surveyselect data=first_sample method=pps sampsize=&m_tot_sample_size out=pps_sample(keep=phrase) seed=-1;
			size visits;
		run;
	
                proc sort data=first_sample;
                        by phrase;
                run;

                proc sort data=pps_sample;
                        by phrase;
                run;

                data pps_sample;
                        merge first_sample pps_sample(in=in2);
                        by phrase;
                        if in2;
                run;
	
		proc contents data=pps_sample;
		run;
	%end;

%mend ppssample;

%ppssample;


***  then use sys to pick data in each group  ***; 
%macro syssample;

	%let j=0;

	%do %until ((&j=10000) or (&m_sum_flag=&m_group_n));

		%let j=%eval(&j+1);

		data sample0;
			set pps_sample;
		run;

		%do i=1 %to &numsample;
			proc sort data=sample0;
				by visits;
			run;

			proc surveyselect data=sample0 %if &i>1 %then %do; (where=(group<1))%end;
				method=sys sampsize=&&ssize&i out=sample&i (keep=phrase) seed=-1;
				control visits;
			run;

			proc sort data=sample0;
				by phrase;
			run;

			proc sort data=sample&i;
				by phrase;
			run;

			data sample0;
				merge sample0 sample&i (in=in2);
				by phrase;
				if in2 then group=&i;
			run;
		%end;

		***  if pps samples more than needed, then pick the wanted samples here  ***;
		data sample0;
			set sample0(where=(group>0));
		run;

		data seo_expr.seo_expr&expr_no.;
			set sample0;
		run;

		proc summary data=seo_expr.seo_expr&expr_no.;
			class group;
			var visits revenue clicks;
			output out=sums mean=;
			run;
		run;
			
		data sums;
			set sums;
			key=1;
		run;

		data sums;
			merge sums(where=(_type_=1)) sums(where=(_type_=0) rename=(visits=overall_vis revenue=overall_rev clicks=overall_clicks)
				keep=key visits clicks revenue _type_);
			by key;
			pct_visits=abs(visits/overall_vis-1);
			pct_rev=abs(revenue/overall_rev-1);
			if pct_visits<=0.05 and pct_rev<=.05 then flag=1;
		run;
	
		title "sys sample for Loop &J";
		proc print data=sums width=min noobs;
		run;

		proc sql;
			select sum(flag) into :m_sum_flag from sums;
		quit;

		%if &m_sum_flag=&m_group_n %then %do;
			x echo The sample result is got;
		%end;

	%end;

%mend syssample;

%syssample;

proc sort data=seo_expr.seo_expr&expr_no. (keep=phrase phrase_id group category_id visits revenue clicks);
	by group phrase;
run;

proc sql;
	select sum(revenue) into: m_tot_sample_revenue from seo_expr.seo_expr&expr_no.;
quit;

%let file=samples_for_seo_expr&expr_no..csv ;

ods listing close;
ods csvall body="&file.";

title "detailed info for the samples in each group";
proc print data=sums(drop=_type_ key) width=min noobs;
run;

title "Print of Samples for SEO_EXPR&expr_no.";
title1 "Total reveune for &m_tot_sample_size. kws in the sample is &m_tot_sample_revenue. from &s_stdt to &s_eddt"; 
title2 "Total revenue for the POOL is &m_tot_visitnew_revenue from &s_stdt to &s_eddt";
proc print data=seo_expr.seo_expr&expr_no.(drop=category_id phrase_id) width=min noobs;
run;

ods csvall close;
ods listing;
      
x uuencode &file. &file. | mail -s "&file.: sample time from &s_stdt to &s_eddt" hsong@abc.com,&notify;

       
        
        
        
        
        
        
        
        
        
        
        










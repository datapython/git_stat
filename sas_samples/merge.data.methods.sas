/* 1: merge;                    */    
/* 2: sql join;                 */ 
/* 3: set a; set b; key=byvar;  */
/* 4: hash table                */




/* 3: set a; set b; key=byvar;  */

data sum_rev(index=(phrase_id));
	set sum_rev;
	set sasdata.%phrase_table_name (keep=phrase phrase_id) key=phrase / unique;
	select(_iorc_);
		when(%sysrc(_sok)) output;
		when(%sysrc(_dsenom)) do;
			phrase_id=.;
			_error_ = 0;
			output;
		end;
		otherwise do;
			put 'E_R_R_O_R: Unexpected value for _IORC_= ' _iorc_;
			put 'Program terminating. Data step iteration # ' _n_;
			put _all_;
			stop;
 	        end;
	end;
run;



*********************************************************************************;
/* 4: hash table                */

data a;
        length sex $20.;
        set sashelp.class;
        test="test a";
run;

data b;
        do i=1 to 15 by 3;
                length sex $20.;
                set sashelp.class point=i;
                testb="test b";
                if name='Alfred' or name='John' then sex='MALE';
                else sex='Female';
                output;
        end;
        stop;
run;

proc print data=a width=min;
run;

proc print data=b width=min;
run;

data c;
        if _n_=1 then do;
                declare hash h (dataset:'b');
		h.definekey('name');
                h.definedata('testb','sex');
                h.definedone();
        end;
	set a;
        length testb $20. sex $20.;
        testb='';
        rc=h.find();
run;

proc print data=c width=min;
run;


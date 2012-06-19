***  1: macro variable can contains macro variable  ***;

proc sql;
	select count(*) into: m_pids_&category_id from deployed_table;
quit;

%put &&m_pids_&category_id;




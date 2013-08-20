/** Given two ad-nodes, get their distance on the ad-node tree **/
/** V2: node1 and node2 are from a table , which include two columns representing the pair of nodes, coded A and B **/

/* given node a, b, merge back to get their parent, grandparent, until the top, the distance is steps to the common xxparents */

&m_l_tdb1;

data phrase_category;
   set tdb1.phrase_category;
   keep category_id category_name top_node_ids;

proc sort data=phrase_category out=phrase_category;
   by category_id;

data cat;
   set phrase_category;
   i=1;
   do while(scan(top_node_ids,i)^="");
      top_node_id=scan(top_node_ids,i)+0;
      i=i+1;
      output;
   end;
   drop top_node_ids i;
proc sort;
   by top_node_id;

	data pdir_node;
	set tdb1.pdir_node;
	keep node_id value parent;
	proc sort; by node_id;
	run;

proc print data=pdir_node(obs=100) width=min; run;

%macro tree_distance(nodes, outdistance);**nodes is the table with two columns nodeA and nodeB representing the pairs of nodes; 


	%macro node2top(cd); 

		proc sort data=&nodes.; by node&cd.; run;

		data getparent(rename=(node_id=node&cd.));
		merge pdir_node(in=a) &nodes(in=b rename=(node&cd.=node_id));
		by node_id;
		if a and b;
		run;

		%do i=1 %to 10; **no node level more than 8 so far;
			data next;
			set getparent(rename=(parent=next&cd._&i.));
			proc sort; by next&cd._&i.;
			run;

proc print data=next(obs=5) width=min; title "next node &i"; run;

			proc sql;
			create table getparent as
			select a.*, b.parent from next a left join pdir_node b
			on a.next&cd._&i=b.node_id;
			quit;

proc print data=getparent(obs=5) width=min; title "getparent &i"; run;
			
		%end;
		
		data out&cd.;
		set getparent;
		rename parent=next&cd._11;
		run;

	%mend;

	%node2top(A);
	%node2top(B);

	proc sort data=outA; by nodeA nodeB; run;
	proc sort data=outB; by nodeA nodeB; run;

	data &outdistance;
	merge outA outB;
	by nodeA nodeB;
	mindistance=99;
	array AA nextA_:;
	array BB nextB_:;
	do a=1 to 11;
		do b=1 to 11;
			if AA(a)=BB(b) and AA(a) ne . and mindistance>a+b then mindistance=a+b; 
		end;
	end;
	run;
	

%mend;



data temp;
input nodeA 7. nodeB 7.;
datalines;
100014 100015
100016 100017
100018 100019
100038 100039
100040 103041
150042 100043
100044 100045
100046 100047
100048 100049
;
run;

%macro testmacro;
%tree_distance(temp, mergedtree);

proc print data=mergedtree width=min; run;

%let file=treedist.csv;
ods csvall body="&file";
proc print data=mergedtree width=min; var nodeA nodeB mindistance; run;
ods csvall close;

X uuencode &file &file |mail -s 'sample tree distance' hsong@nextag.com;
%mend;

%testmacro;

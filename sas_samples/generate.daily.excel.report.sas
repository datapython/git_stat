****  zz from http://bbs.pinggu.org/thread-1444265-1-1.html ***;

/*  该sas件旨在说明如何编写一次完成以后不用任何人手更改（包括更改日期、excel的格式等）的常规报表；
    如用邮件自动发送程序，则还可省略发送邮件的过程，做到一次编写，1需跟进（前提是程序经过检验完善）；
        可根据个人情况举一反三使用；
	    本来自"OUR SAS"群-"统计-小风"
	    */

options noxwait noxsync;
x '"D:\报表模板.xlsx"';     /* 该件为固定的报表模板，可以事先调整好单元格格式、字体颜色，事先写好其他不变的内容 */
data _null_;
	rc=sleep(10);               /* sas睡眠10秒，是为了给打开上述件留时间 */
run;

data _null_;                /* 此处设定各类时间，比如你要读取的件是包含时间的，如test2012-05-16，就是用当天的时间、
	sas程序运行的时间去得到这个"2012-05-16";另外一种是你要生成的excel件是包含时间的，也在这里处理得出 */
	x=put(date()-1,yymmdd10.);   /* 比如每日运行这个程序，处理前一日的件，就是用date()-1 */
	y=substr(x,6,2)||substr(x,9,2)||"b";
	z=compress(input(substr(x,6,2),best8.)||"."||input(substr(x,9,2),best8.));
	件名为 sql(5.16).xlsx  */
	put x;
	y= compress('[save.as("E:\MailFile\sql('||&path2||').xlsx")]');  /* 存储到邮件件夹，这样由邮件自动发送excel出去 */
	put y;
	put '[quit]';
	run;
	
	/*整个程序如上，然后txt写如下内容另存为bat件，在windows-附件-系统工具-任务计划程序里面设置每日凌晨运行这个bat即可：
	D:
	cd: "D:\sas_program\sas\sasfoundation\9.2\"
	sas.exe -sysin "D:\thisprogramname.sas" -altlog "D:\test\log.log"
	*/
	
	/* 上述bat第二行是你sas程序的路径，第三行表示执行的sas程序的路径和名字，然后将sas运行的日志写入到log.log中，
	以便事后查看日志 */call symput("path",y);
	call symput("path2",z);
run;

%let log=alla_&path;        /* 我要处理的件名就是 alla_0516b 这种形式 */

libname result "D:\test";
data temp1(compress=yes);
	set result.&log;            /* 类似这样应用 */
run;

/* 中间是你数据处理的过程，省略 */

filename r1 dde 'excel|[报表模板.xlsx]自定义表名1!r5c1:r60c6' ;  /* 对某张表某些单元格进行写入 */
data _null_;
	set result1;
	file r1 notab linesize=2000;    /* DDE默认空格为分隔符，如果一个变量中间有空格将会分开到两个单元格，用notab即可避免，
	linesize赋予一个足够大的值，则过长的变量不会错行 */
	put date '09'x time '09'x source '09'x duration '09'x sql '09'x type;
run;

filename r1 dde 'excel|[报表模板.xlsx]自定义表名2!r5c1:r60c6' ;   /*  继续写入下一张表 */
data _null_;
	set result2;
	file r1 notab linesize=2000;
	put date '09'x time '09'x source '09'x duration'09'x  sql '09'x type;
run;

filename r1 dde "excel|system";  
data _null_;
	file r1;
	put '[workbook.activate("自定义表名2")]';  /* 激活其中一张表 */
	put '[row.height(0,"A1:A1",false,3)]';    /* 调整行高；类似这样的跟vba比较像 */
	put '[workbook.activate("自定义表名1")]';
	put '[row.height(0,"A1:A1",false,3)]';
	x= compress('[save.as("D:\sql('||&path2||').xlsx")]');  /* 存储一个备份到某个路径，


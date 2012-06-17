****  zz from http://bbs.pinggu.org/thread-1444265-1-1.html ***;

/*  ��sas��ּ��˵����α�дһ������Ժ����κ����ָ��ģ������������ڡ�excel�ĸ�ʽ�ȣ��ĳ��汨��
    �����ʼ��Զ����ͳ����򻹿�ʡ�Է����ʼ��Ĺ��̣�����һ�α�д��1�������ǰ���ǳ��򾭹��������ƣ���
        �ɸ��ݸ��������һ����ʹ�ã�
	    ������"OUR SAS"Ⱥ-"ͳ��-С��"
	    */

options noxwait noxsync;
x '"D:\����ģ��.xlsx"';     /* �ü�Ϊ�̶��ı���ģ�壬�������ȵ����õ�Ԫ���ʽ��������ɫ������д��������������� */
data _null_;
	rc=sleep(10);               /* sas˯��10�룬��Ϊ�˸�����������ʱ�� */
run;

data _null_;                /* �˴��趨����ʱ�䣬������Ҫ��ȡ�ļ��ǰ���ʱ��ģ���test2012-05-16�������õ����ʱ�䡢
	sas�������е�ʱ��ȥ�õ����"2012-05-16";����һ������Ҫ���ɵ�excel���ǰ���ʱ��ģ�Ҳ�����ﴦ��ó� */
	x=put(date()-1,yymmdd10.);   /* ����ÿ������������򣬴���ǰһ�յļ���������date()-1 */
	y=substr(x,6,2)||substr(x,9,2)||"b";
	z=compress(input(substr(x,6,2),best8.)||"."||input(substr(x,9,2),best8.));
	����Ϊ sql(5.16).xlsx  */
	put x;
	y= compress('[save.as("E:\MailFile\sql('||&path2||').xlsx")]');  /* �洢���ʼ����У��������ʼ��Զ�����excel��ȥ */
	put y;
	put '[quit]';
	run;
	
	/*�����������ϣ�Ȼ��txtд�����������Ϊbat������windows-����-ϵͳ����-����ƻ�������������ÿ���賿�������bat���ɣ�
	D:
	cd: "D:\sas_program\sas\sasfoundation\9.2\"
	sas.exe -sysin "D:\thisprogramname.sas" -altlog "D:\test\log.log"
	*/
	
	/* ����bat�ڶ�������sas�����·���������б�ʾִ�е�sas�����·�������֣�Ȼ��sas���е���־д�뵽log.log�У�
	�Ա��º�鿴��־ */call symput("path",y);
	call symput("path2",z);
run;

%let log=alla_&path;        /* ��Ҫ����ļ������� alla_0516b ������ʽ */

libname result "D:\test";
data temp1(compress=yes);
	set result.&log;            /* ��������Ӧ�� */
run;

/* �м��������ݴ���Ĺ��̣�ʡ�� */

filename r1 dde 'excel|[����ģ��.xlsx]�Զ������1!r5c1:r60c6' ;  /* ��ĳ�ű�ĳЩ��Ԫ�����д�� */
data _null_;
	set result1;
	file r1 notab linesize=2000;    /* DDEĬ�Ͽո�Ϊ�ָ��������һ�������м��пո񽫻�ֿ���������Ԫ����notab���ɱ��⣬
	linesize����һ���㹻���ֵ��������ı���������� */
	put date '09'x time '09'x source '09'x duration '09'x sql '09'x type;
run;

filename r1 dde 'excel|[����ģ��.xlsx]�Զ������2!r5c1:r60c6' ;   /*  ����д����һ�ű� */
data _null_;
	set result2;
	file r1 notab linesize=2000;
	put date '09'x time '09'x source '09'x duration'09'x  sql '09'x type;
run;

filename r1 dde "excel|system";  
data _null_;
	file r1;
	put '[workbook.activate("�Զ������2")]';  /* ��������һ�ű� */
	put '[row.height(0,"A1:A1",false,3)]';    /* �����иߣ����������ĸ�vba�Ƚ��� */
	put '[workbook.activate("�Զ������1")]';
	put '[row.height(0,"A1:A1",false,3)]';
	x= compress('[save.as("D:\sql('||&path2||').xlsx")]');  /* �洢һ�����ݵ�ĳ��·����


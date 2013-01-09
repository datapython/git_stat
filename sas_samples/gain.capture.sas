*** How to evaluation the prediction is good or not? R^2? MSE? ***;
*** Let us do like gain in categorical data analysis: on validate data set, proc rank data into 10 groups by predicted value of response var  ***;
*** then calculate the sum of true value of response var in each group. The more the top decimals, the better the model is                    ***;

%macro gainvalid(indata, p_var, cap_var);
        proc rank data=&indata out=after_rank groups=10 descending;
                var &p_var;
                ranks ranks;
        run;

        proc means data=after_rank nway n sum;
                class ranks;
                var &p_var &cap_var;
                output out=sums sum=;
	run;

        proc sql;
               select sum(&cap_var) into: m_&cap_var from &indata;
        quit;

        data sums;
                set sums;
                pct=&cap_var/&&m_&cap_var;
                cum_pct+pct;
        run;

        proc print data=sums width=min;
        run;
%mend gainvalid;

%gainvalid(emws1.reg_validate, p_log_revenue, revenue);


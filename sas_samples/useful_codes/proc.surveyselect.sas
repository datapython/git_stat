**  pps sample in each strata: example from SAS  ;
title1 'Hospital Utilization Survey';
title2 'Stratified PPS Sampling';

proc surveyselect data=HospitalFrame method=pps_brewer seed=48702 out=SampleHospitals;
	size SizeMeasure;                ** pps size prop to sizemeasure;
      	strata Type Size notsorted;      ** strata in each type, size;
run;


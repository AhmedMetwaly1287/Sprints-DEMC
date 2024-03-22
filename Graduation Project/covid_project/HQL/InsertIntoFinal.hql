set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE covid_db.covid_final_output PARTITION(country_name)
SELECT total_deaths,total_cases,country
FROM covid_db.covid_ds_partitioned 
WHERE country IS NOT NULL AND country!='World' 
GROUP BY total_deaths,total_cases,country; 

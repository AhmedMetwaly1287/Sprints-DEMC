set hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE covid_db.covid_ds_partitioned PARTITION(COUNTRY_NAME)
SELECT *,country FROM covid_db.covid_staging WHERE Country IS NOT NULL LIMIT 3;

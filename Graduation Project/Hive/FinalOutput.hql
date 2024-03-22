CREATE EXTERNAL TABLE covid_db.covid_final_output 
(
 NUMBER_OF_DEATHS 			                DOUBLE,
 NUMBER_OF_TESTS 			                DOUBLE
)
PARTITIONED BY (COUNTRY_NAME STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED by ','
STORED as TEXTFILE
LOCATION '/user/cloudera/ds/COVID_FINAL_OUTPUT';
#!/bin/bash

source_dir="/home/cloudera/covid_project/landing_zone/COVID_SRC_LZ"
target_dir="/user/cloudera/ds/COVID_HDFS_LZ"
partitioned_dir="/user/cloudera/ds/COVID_HDFS_PARTITIONED"
final_dir="/user/cloudera/ds/COVID_FINAL_OUTPUT"
dataset_name="covid-19.csv"


hadoop fs -mkdir -p $target_dir

echo "Target Directory created successfully."


hadoop fs -put $source_dir/$dataset_name $target_dir

echo "Moved the Dataset from Source to Target."

hadoop fs -mkdir -p $partitioned_dir

echo "Created dir for the partitioned Hive Table."

hadoop fs -mkdir -p $final_dir

echo "Created dir for the Final Output."



echo "All Operations completed successfully."

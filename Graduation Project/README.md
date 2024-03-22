<h1>COVID-19 Automated Workflow using Oozie</h1>



<h2>Project Description</h2>

<p><strong>In this Project, An automated pipeline was built using Big Data Tools such as Apache Oozie, Apache Hive and Shell Script</strong></p>

<h2>Tools & Languages Used</h2>

<ol>
    <li>
        <strong>Cloudera CDH 5.8.0 Virtual Machine Powered By VMWare</strong>
    </li>
    <li>
        <strong>Apache HUE</strong>
    </li>
     <li>
        <strong>Apache Oozie</strong>
    </li>
     <li>
        <strong>Apache Hive</strong>
    </li>

  <li>
    <strong>Cloudera Manager</strong>

<ul>To Monitor the health of the Cluster and the servies running on it, monitor the resource usage of the cluster and adjust the configuration of services as needed</ul>
</li>
  <li>
        <strong>Microsoft PowerBI</strong>
    </li>
  <li>
        <strong>Python</strong>
    </li>
  <li>
        <strong>WinSCP</strong>
    </li>
</ol>

<h2>Detailed Description of the Project Steps</h2>

<h3>1. Dataset Transformation</h3>

<p><strong>COVID-19 Dataset was used in this project, initially the project has had an issue with inconsistent whitespace between each column, 
resulting in errors when trying to ingest the data into the Staging Table using Hive so a simple Python Script was leveraged to replace the inconsistent whitespaces with a comma to faciliate the Data Ingestion Stage (Refer to Dataset/transformDS.py)</strong></p>

<h3>2. File Preperation</h3>

<p><strong>A simple Shell Script was used to create the directory that will contain all the necessary files for our Apache Oozie workflow, this file was transported to the VM using WinSCP and then executed via Terminal</strong></p>

```bash
#!/bin/bash

# Your bash code here
mkdir /home/cloudera/covid_project
echo "Main Project dir Created Successfully"

mkdir /home/cloudera/covid_project/landing_zone
echo "Landing_zone Sub dir Created Successfully"

mkdir /home/cloudera/covid_project/landing_zone/COVID_SRC_LZ
echo "Dataset dir Created Successfully"

mkdir /home/cloudera/HQL
echo "HQL Scripts dir Created Successfully"

mkdir /home/cloudera/script
echo "Shell Script dir Created Successfully"

echo "All Dirs Created Successfully"
```
<p><strong>The COVID-19 Dataset was then transported to "/home/cloudera/covid_project/landing_zone/COVID_SRC_LZ" Directory for later use</strong></p>

<p><strong>Another Shell Script was leveraged for copying and moving the dataset to HDFS and also create directories where the partitioned Data residing inside Hive Tables will be stored</strong></p>

```bash
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
```
<p><strong>(Refer to HDFS for Shell Script Files)</strong></p>

<h3>3. Data Preperation, Ingestion and Partitioning</h3>

<p><strong>After Dataset has been moved to HDFS, A Database under the name "covid_db" is then created and put to use</strong></p>

```hql
CREATE database IF NOT EXISTS covid_db;

use covid_db;
```

<p><strong>After the creation of the database, The Staging table is then created with the following schema</strong></p>

```hql
CREATE TABLE IF NOT EXISTS covid_db.covid_staging 
(
 Country 			                STRING,
 Total_Cases   		                DOUBLE,
 New_Cases    		                DOUBLE,
 Total_Deaths                       DOUBLE,
 New_Deaths                         DOUBLE,
 Total_Recovered                    DOUBLE,
 Active_Cases                       DOUBLE,
 Serious		                  	DOUBLE,
 Tot_Cases                   		DOUBLE,
 Deaths                      		DOUBLE,
 Total_Tests                   		DOUBLE,
 Tests			                 	DOUBLE,
 CASES_per_Test                     DOUBLE,
 Death_in_Closed_Cases     	        STRING,
 Rank_by_Testing_rate 		        DOUBLE,
 Rank_by_Death_rate    		        DOUBLE,
 Rank_by_Cases_rate    		        DOUBLE,
 Rank_by_Death_of_Closed_Cases   	DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED by ','
STORED as TEXTFILE
LOCATION '/user/cloudera/ds/COVID_HDFS_LZ'
tblproperties ("skip.header.line.count"="1");
```

<p><strong>The Data residing inside the COVID-19 Dataset File is then loaded into the Staging table using this script</strong></p>

```hql
LOAD DATA INPATH '/home/cloudera/ds/COVID_HDFS_LZ/covid-19.csv' 
INTO TABLE covid_db.covid_staging;
```

<p><strong>An external, partitioned table is then created, and the data is then stored in the form of partitioned ORC Files by Country_Name </strong></p>

```hql
CREATE EXTERNAL TABLE IF NOT EXISTS covid_db.covid_ds_partitioned 
(
 Country 			                STRING,
 Total_Cases   		                DOUBLE,
 New_Cases    		                DOUBLE,
 Total_Deaths                       DOUBLE,
 New_Deaths                         DOUBLE,
 Total_Recovered                    DOUBLE,
 Active_Cases                       DOUBLE,
 Serious		                  	DOUBLE,
 Tot_Cases                   		DOUBLE,
 Deaths                      		DOUBLE,
 Total_Tests                   		DOUBLE,
 Tests			                 	DOUBLE,
 CASES_per_Test                     DOUBLE,
 Death_in_Closed_Cases     	        STRING,
 Rank_by_Testing_rate 		        DOUBLE,
 Rank_by_Death_rate    		        DOUBLE,
 Rank_by_Cases_rate    		        DOUBLE,
 Rank_by_Death_of_Closed_Cases   	DOUBLE
)
PARTITIONED BY (COUNTRY_NAME STRING)
STORED as ORC
LOCATION '/user/cloudera/ds/COVID_HDFS_PARTITIONED';
```

<p><strong>The partitioned table is then filled with data residing inside the staging table using this script</strong></p>

```hql
set hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE covid_db.covid_ds_partitioned PARTITION(COUNTRY_NAME)
SELECT *,country FROM covid_db.covid_staging WHERE Country IS NOT;
```
(Due to Machine Resource Limitations, The number of records inserted inside the partitioned table is limited to 3 records)

<p><strong>Finally, another external table was created, the purpose of the FINAL_OUTPUT Table is to hold the data that will then be used for Visualization</strong>, The data in this table will be stored in the form of TEXTFILE</p>

```hql
CREATE EXTERNAL TABLE covid_db.covid_final_output 
(
 NUMBER_OF_DEATHS 			                DOUBLE,
 NUMBER_OF_TESTS 			                DOUBLE
)
PARTITIONED BY (COUNTRY_NAME STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED by ','
STORED as TEXTFILE
LOCATION '/user/cloudera/ds/COVID_FINAL_OUTPUT';
```

<p><strong>Filling the FINAL_OUTPUT table with data residing inside the partitioned table.</strong></p>

```hql
set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE covid_db.covid_final_output PARTITION(country_name)
SELECT total_deaths,total_cases,country
FROM covid_db.covid_ds_partitioned 
WHERE country IS NOT NULL AND country!='World' 
GROUP BY total_deaths,total_cases,country; 
```
(Due to prior limiations, the number of records in this external table is limited to 2, however, with more resources there is no issues with more records being inserted)

(Refer to Hive folder for the scripts)

<p>These scripts are a critical part of our Oozie Workflow that will be created later on</p>

<h3>4. Workflow Creation</h3>

<p><strong>Apache Hadoop User Experience (HUE) UI is leveraged to create the Oozie workflow using simple Drag and Drop system, you can see the stages the workflow goes through and the sequence of steps along the properties of the workflow</strong></p>

```xml
<workflow-app name="SprintsWorkflow" xmlns="uri:oozie:workflow:0.5">
  <global>
            <configuration>
                <property>
                    <name></name>
                    <value></value>
                </property>
            </configuration>
  </global>
    <start to="shell-4f63"/>
    <kill name="Kill">
        <message>Action failed, error message[${wf:errorMessage(wf:lastErrorNode())}]</message>
    </kill>
    <action name="hive2-4fea" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/CreateDB.hql</script>
        </hive2>
        <ok to="hive2-12cd"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-12cd" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/CreateStagingTable.hql</script>
        </hive2>
        <ok to="hive2-9b1a"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-9b1a" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/LoadIntoStagingTable.hql</script>
        </hive2>
        <ok to="hive2-4be9"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-4be9" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/CreatePartitionedTable.hql</script>
        </hive2>
        <ok to="hive2-84ff"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-84ff" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/InsertIntoPartitionedTable.hql</script>
        </hive2>
        <ok to="hive2-7d36"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-7d36" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/CreateFinalOutput.hql</script>
        </hive2>
        <ok to="hive2-e0c3"/>
        <error to="Kill"/>
    </action>
    <action name="hive2-e0c3" cred="hive2">
        <hive2 xmlns="uri:oozie:hive2-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <jdbc-url>jdbc:hive2://quickstart.cloudera:10000/default</jdbc-url>
            <script>/user/cloudera/covid_project/HQL/InsertIntoFinal.hql</script>
        </hive2>
        <ok to="End"/>
        <error to="Kill"/>
    </action>
    <action name="shell-4f63">
        <shell xmlns="uri:oozie:shell-action:0.1">
            <job-tracker>${jobTracker}</job-tracker>
            <name-node>${nameNode}</name-node>
            <exec>/user/cloudera/covid_project/script/Script.sh</exec>
              <capture-output/>
        </shell>
        <ok to="hive2-4fea"/>
        <error to="Kill"/>
    </action>
    <end name="End"/>
</workflow-app>
```

```properties
oozie.use.system.libpath=True
security_enabled=False
dryrun=False
jobTracker=localhost:8032
nameNode=hdfs://quickstart.cloudera:8020
```
(Refer to Oozie file for more)

<h3>5. Workflow Execution</h3>

<p><strong>Apache Hadoop User Experience (HUE) UI is then leveraged to execute the Oozie workflow using ,in the following screenshots, you can see the stages the workflow goes through and the sequence of steps also the result after executing the workflow and the result of executing the workflow with respect to Hive, HDFS</strong></p>

<h4>Workflow Execution</h4>

![Screenshot 2024-03-21 173555](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/7c2934d5-aa71-4576-bcb0-ca73980b45d4)

![Screenshot 2024-03-21 173614](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/ac4b48ff-9030-40af-8cfc-48f0141c16e8)

![Screenshot 2024-03-21 173631](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/a3d798ba-9375-4615-9482-d4438031a551)


<h4>Hive</h4>

![Screenshot 2024-03-21 173440](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/91cb06b1-226c-42f3-a87b-8e5b7e9a8d87)

![Screenshot 2024-03-21 173503](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/8813e2bd-c725-4cbd-a3ae-8f12e2ed0df9)

(Due to Machine Resource Limitations, The number of records inserted inside the partitioned table is limited to 3 records)

![Screenshot 2024-03-21 173524](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/10a2f2fa-de0f-4440-b148-1ba03b7a0240)

(Due to Prior Machine Resource Limitations, The number of records inserted inside the partitioned table is limited to 2 records)

<h4>HDFS</h4>

<p>Result of running Script.sh</p>

![Screenshot 2024-03-21 173826](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/b0f91a2e-4ed6-4bab-b5cb-acd89fff7453)

<p>Result of Running All HQL Scripts</p>

![Screenshot 2024-03-21 173853](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/7bc25ffb-c87b-40f9-8767-8c4db4da4a10)

![Screenshot 2024-03-21 173917](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/31ac9702-3ca1-4bdf-8564-7046bac99163)



![Screenshot 2024-03-21 173941](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/1180400d-35c3-4867-b482-eb5a4d1e645a)



<h3>6. Data Visualization</h3>

<p><strong>Finally, the result is visualized using Microsoft PowerBI, where an interactive, detailed dashboard was created </strong></p>

![image](https://github.com/AhmedMetwaly1287/Sprints-DEMC/assets/139663311/1d0964bc-8ed6-4b5c-b51d-832c35591f96)

(Refer to Data Visualization file for more)



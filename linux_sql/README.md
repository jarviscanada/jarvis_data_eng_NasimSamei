# Linux Cluster Monitoring Agent
# Introduction
The Linux cluster monitor agent is a tool to collect resource statics for each Linux node in a Linux cluster. It uses a series
of bash script files first to start and create a PSQL docker instance. 
Next, it collects hardware specifications and data usage statistics using host_info.sh and host_usage.sh and inserts them into the host_agent database in the PSQL instance. 
The usage data statics are stored every minus. The result is saved in a log file to inform the resource planning for their future economical decisions.

# Quick Start


* Creating and start a PSQL docker instance using  psql_docker.sh
```` ./scripts/psql_docker.sh create [db_username][db_password] ````
* Create host_info table and host_usage table using ddl.sql.
```` psql -h localhost -U [db_username] -d host_agent -f sql/ddl.sql````
* Insert hardware specification data into database called host_agent using host_info script.
````./scripts/host_info.sh [psql host] [port] host_agent [db_username] [db_password]````
* Insert usage information data into host_agent Database using host_usage script.
````./scripts/host_usage.sh [psql host] [port] host_agent [db_username] [db_password]````
* To collect usage data automatically every minute
``` corntab -e```
- Add the below line in the editor
```` * * * * * bash [full/path/to]/linux_sql/scripts/host_usage.sh [psql host] [port] host_agent [db_username] [db_password] &>/tmp/host_usage.log````
# Implementation
First, we create or start a PSQL instance using psql_docker. 
Then the host_info table and host_uage tables are created for collecting the hardware 
specification data and usage data respectively using ddl.sql. host_info.sh is used to 
collect hardware specification data and insert them into the host_info table. Similarly, the host_usage.sh is used to collect usage data and save them into the related table. 
Finally, we set up a crontab to insert data usage data to the related table every minute.
## Architecture
## Scripts

* psql_docker.sh: To create, start and stop the psql instance.
Usage ````./scripts/psql_docker.sh start|stop|create [db_username][db_password]````
*  ddl.sql: To create 
* host_info.sh: Collect hardware information and insert them into host_agent DB. Usage:```bash scripts/host_info.sh psql_host psql_port db_name psql_user psql_password```
* host_usage.sh: Collect usage information and insert them into host_info DB. Usage```bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password```
* crontab: runs every minute and execute host_usage to insert usage information into host_agent DB.

# Database Modeling

## host_info table


| id | hostname | cpu_number | cpu_architecture | cpu_model                       | cpu_mhz | L2_cache | total_mem | timestamp 
| ---|-------| -----------|------------------|---------------------------------|---------|----------|-----------|----------
| 1  | jrvs-remote-desktop-centos7      |     4      |      x86_64      | Intel(R) Xeon(R) CPU @ 2.30GHz  |2300.000 |    256   |   601324  | 2022-10-19 17:49:53

## host_usage table

| timestamp           | host_id| memory_free | cpu_idle | cpu_kernel     | disk_io | disk_available 
| --------------------|--------|-------------|----------|----------------|---------|----------------
| 2022-10-19 17:49:53 | 1      |   256       | 95       | 0              | 0       | 31220

# Future Improvements

* Add a query checking for host failure
* Come up with an approach to provide hardware specifications updated
--USED https://theinformationlab.nl/2022/08/18/frosty-friday-developing-snowflake-skills/ for guidance 

USE ROLE ACCOUNTADMIN;
--Create a warehouse
CREATE WAREHOUSE frosty_week1
WITH
WAREHOUSE_SIZE = XSMALL
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 300
STATEMENT_TIMEOUT_IN_SECONDS = 600;

--Create a database
CREATE OR REPLACE DATABASE snowflake_frosty_week1;

--Create a schema
CREATE SCHEMA week1;

--Use the above
USE WAREHOUSE frosty_week1;
USE DATABASE snowflake_frosty_week1;
USE SCHEMA week1;

--Create CSV file format
CREATE OR REPLACE file format week1_csv_format
type = 'CSV'
field_delimiter = ','
skip_header = 1;

--Create a stage
CREATE or REPLACE STAGE CSV_STAGE_EXTERNAL
    FILE_FORMAT = week1_csv_format
URL = 's3://frostyfridaychallenges/challenge_1/';

--List objects in stage
LIST @CSV_STAGE_EXTERNAL;

--CHECK CSV IN STAGE
SELECT $1, $2, $3
FROM @CSV_STAGE_EXTERNAL (FILE_FORMAT => week1_csv_format);

--Create a table
CREATE OR REPLACE TABLE
snowflake_frosty_week1.week1.CSV_TABLE
    (C1 VARCHAR);

--view empty table
SELECT * FROM CSV_TABLE;

--load into empty table
COPY INTO 
snowflake_frosty_week1.week1.CSV_TABLE
FROM @CSV_STAGE_EXTERNAL;

--
SELECT * FROM CSV_TABLE;
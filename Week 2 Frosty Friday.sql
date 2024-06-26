USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE DATABASE FF_WEEK2;

--USE ROLE accountadmin;
--GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;

USE DATABASE FF_WEEK2;

CREATE OR REPLACE FILE FORMAT INGEST_PARQUET
TYPE = 'parquet';


CREATE OR REPLACE STAGE ff_week2_parquet;

LIST @ff_week2_parquet;

--SELECT $1 FROM @ff_week2_parquet;

--Infer the schema
SELECT* FROM TABLE(infer_schema(
    location => '@ff_week2_parquet',
    file_format => 'INGEST_PARQUET'
));

--Create table using infer_schema
create table week2ff using template(
    select array_agg(object_construct(*))
    from table(
    infer_schema(
    location=>'@ff_week2_parquet',
    file_format=>'INGEST_PARQUET'
    )
    )
);

--Load the parquet file using MATCH_BY_COLUMN_NAME.
copy into week2ff from '@ff_week2_parquet'
file_format = (format_name = 'INGEST_PARQUET') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;

select * from week2ff;

CREATE VIEW week2ff_view as
select "employee_id", "dept", "job_title" from week2ff;

CREATE OR REPLACE STREAM week2ff_view_stream on view week2ff_view;

UPDATE week2ff SET "country" = 'Japan' WHERE "employee_id" = 8;
UPDATE week2ff SET "last_name" = 'Forester' WHERE "employee_id" = 22;
UPDATE week2ff SET "dept" = 'Marketing' WHERE "employee_id" = 25;
UPDATE week2ff SET "title" = 'Ms' WHERE "employee_id" = 32;
UPDATE week2ff SET "job_title" = 'Senior Financial Analyst' WHERE "employee_id" = 68;

select * from week2ff_view;



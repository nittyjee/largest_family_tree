--For revisions, copy-paste everything below in another table and change the following:

/*
Italian_Emigration_to_merge_1
Italian_Emigration_to_merge_2
Italian_Emigration_to_merge_3
Italian_Emigration_first_merge
Italian_Emigration_second_merge


Gen_7165181_Rejoin
Gen_7165181_Rejoin

Gen_7165181_Rejoin_Transmission
Gen_7165181_Rejoin_Transmission

Gen_7165181_Rejoin_Transmission_Reduced
Gen_7165181_Rejoin_Transmission_Reduced

Gen_7165181_Rejoin_for_joining
Gen_7165181_Rejoin_for_joining

Gen_7165181_Rejoin_pulsation
Gen_7165181_Rejoin_pulsation

Gen_7165181_Rejoin_to_merge1
Gen_7165181_Rejoin_to_merge1

Gen_7165181_Rejoin_to_merge2
Gen_7165181_Rejoin_to_merge2

Gen_7165181_Rejoin_for_joining_1
Gen_7165181_Rejoin_for_joining_1

Gen_7165181_Rejoin_for_joining_2
Gen_7165181_Rejoin_for_joining_2

Gen_7165181_Rejoin_pulsation_1
Gen_7165181_Rejoin_pulsation_1

Gen_7165181_Rejoin_pulsation_2
Gen_7165181_Rejoin_pulsation_2

Gen_7165181_Rejoin_pulsation_1_Reduced
Gen_7165181_Rejoin_pulsation_1_Reduced

Gen_7165181_Rejoin_pulsation_2_Reduced
Gen_7165181_Rejoin_pulsation_2_Reduced
*/

--Join Gen_7165181_Rejoin to Gen

ALTER TABLE Gen_7165181_Rejoin RENAME COLUMN child_id TO id;

DROP TABLE IF EXISTS Parents_Children_7165181_Gen CASCADE;
SELECT * INTO Parents_Children_7165181_Gen
FROM Gen_7165181_Rejoin G
JOIN Gen P using (Id)












-- (2) Generate table by months and manipulate

--(2.1) Multiply by months between birthdate of youngest parent and birthdate of children
DROP TABLE IF EXISTS Gen_7165181_Rejoin_Transmission CASCADE;
SELECT * INTO Gen_7165181_Rejoin_Transmission
FROM
        Gen_7165181_Rejoin AS I
    JOIN
        num
            ON num.mos <= I.tot_mo

--Result: 189,588 rows affected, 1295 ms execution time

--(2.2) Add YR Column to Gen_7165181_Rejoin_Transmission

--(2.2.1) Add Start_Date and End_Date
ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_num_start FLOAT;

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_num_end FLOAT;

--(2.2.2) Divide by 12 for year
UPDATE Gen_7165181_Rejoin_Transmission SET YR_num_start = (mos-1)/12;
UPDATE Gen_7165181_Rejoin_Transmission SET YR_num_end = (mos)/12;

/*

--This appears to have ended up being unnecessary - the field type
--"integer" made this round down anyway

--Round down
--Add YR_Num column
ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_Num_Start integer;

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_Num_End integer;



UPDATE Gen_7165181_Rejoin_Transmission SET YR_Num_Start = FLOOR(YR_temp_start);
UPDATE Gen_7165181_Rejoin_Transmission SET YR_Num_End = FLOOR(YR_temp_end);

*/


--(2.2.3) Create year column - add YR_Num to late_yr
ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_Start integer;

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD YR_End integer;

UPDATE Gen_7165181_Rejoin_Transmission SET YR_Start = late_yr + YR_Num_Start;
UPDATE Gen_7165181_Rejoin_Transmission SET YR_End = late_yr + YR_Num_End;


--(2.2.4) Create MO_Start and MO_End

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD MO_Start integer;

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD MO_End integer;

UPDATE Gen_7165181_Rejoin_Transmission SET MO_Start = mos-(YR_Num_Start*12);
UPDATE Gen_7165181_Rejoin_Transmission SET MO_End = (mos+1)-(YR_Num_End*12);

--(2.2.5) Start_Date
ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD Start_Date character varying(250);

UPDATE Gen_7165181_Rejoin_Transmission SET Start_Date = CONCAT (YR_Start,'-','0',MO_Start)
WHERE
MO_Start = 1 OR
MO_Start = 2 OR
MO_Start = 3 OR
MO_Start = 4 OR
MO_Start = 5 OR
MO_Start = 6 OR
MO_Start = 7 OR
MO_Start = 8 OR
MO_Start = 9;

UPDATE Gen_7165181_Rejoin_Transmission SET Start_Date = CONCAT (YR_Start,'-',MO_Start)
WHERE
MO_Start = 10 OR
MO_Start = 11 OR
MO_Start = 12;

--(2.2.6) End_Date

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD End_Date character varying(250);

UPDATE Gen_7165181_Rejoin_Transmission SET End_Date = CONCAT (YR_End,'-','0',MO_End)
WHERE
MO_End = 1 OR
MO_End = 2 OR
MO_End = 3 OR
MO_End = 4 OR
MO_End = 5 OR
MO_End = 6 OR
MO_End = 7 OR
MO_End = 8 OR
MO_End = 9;

UPDATE Gen_7165181_Rejoin_Transmission SET End_Date = CONCAT (YR_End,'-',MO_End)
WHERE
MO_End = 10 OR
MO_End = 11 OR
MO_End = 12;


--(2.3) Create lat/lon for each

--(2.3.1) lon add and lat add

ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD LAT1_ADD float(4),
ADD LON1_ADD float(4),
ADD LAT2_ADD float(4),
ADD LON2_ADD float(4)
;

UPDATE Gen_7165181_Rejoin_Transmission set LAT1_ADD = (LAT-LAT_1)/tot_mo;
UPDATE Gen_7165181_Rejoin_Transmission set LAT2_ADD = (LAT-LAT_2)/tot_mo;
UPDATE Gen_7165181_Rejoin_Transmission set LON1_ADD = (LON-LON_1)/tot_mo;
UPDATE Gen_7165181_Rejoin_Transmission set LON2_ADD = (LON-LON_2)/tot_mo;

--(2.3.2) Add lat/lon
ALTER TABLE Gen_7165181_Rejoin_Transmission
ADD LAT1 float(4),
ADD LON1 float(4),
ADD LAT2 float(4),
ADD LON2 float(4)
;

UPDATE Gen_7165181_Rejoin_Transmission SET LAT1 = LAT_1+(mos*LAT1_ADD);
UPDATE Gen_7165181_Rejoin_Transmission SET LON1 = LON_1+(mos*LON1_ADD);
UPDATE Gen_7165181_Rejoin_Transmission SET LAT2 = LAT_2+(mos*LAT2_ADD);
UPDATE Gen_7165181_Rejoin_Transmission SET LON2 = LON_2+(mos*LON2_ADD);



--(2.4) Create table that is reduced to just start and end dates and lat/lon

DROP TABLE IF EXISTS Gen_7165181_Rejoin_Transmission_Reduced CASCADE;
SELECT * INTO Gen_7165181_Rejoin_Transmission_Reduced
FROM Gen_7165181_Rejoin_Transmission;

ALTER TABLE Gen_7165181_Rejoin_Transmission_Reduced
--DROP COLUMN sequence,
DROP COLUMN id_2,
DROP COLUMN lon_2,
DROP COLUMN lat_2,
--DROP COLUMN country_2,
DROP COLUMN continent_2,
DROP COLUMN res_2,
DROP COLUMN byear_2,
DROP COLUMN dyear_2,
DROP COLUMN id_1,
DROP COLUMN lon_1,
DROP COLUMN lat_1,
--DROP COLUMN country_1,
DROP COLUMN continent_1,
DROP COLUMN res_1,
DROP COLUMN byear_1,
DROP COLUMN dyear_1,
DROP COLUMN idx_2,
DROP COLUMN parent_id_2,
DROP COLUMN idx_1,
DROP COLUMN parent_id_1,
DROP COLUMN lon,
DROP COLUMN lat,
DROP COLUMN country,
DROP COLUMN continent,
DROP COLUMN res,
--DROP COLUMN byear,
DROP COLUMN dyear,
DROP COLUMN gender,
DROP COLUMN late_yr,
DROP COLUMN diff,
DROP COLUMN tot_mo,
DROP COLUMN mos,
--DROP COLUMN yr_temp_start,
--DROP COLUMN yr_temp_end,
DROP COLUMN yr_num_start,
DROP COLUMN yr_num_end,
DROP COLUMN yr_start,
DROP COLUMN yr_end,
DROP COLUMN mo_start,
DROP COLUMN mo_end,
DROP COLUMN lat1_add,
DROP COLUMN lon1_add,
DROP COLUMN lat2_add,
DROP COLUMN lon2_add
RESTRICT;

--Run Count on Gen_7165181_Rejoin_Transmission_Reduced
SELECT COUNT(*) FROM Gen_7165181_Rejoin_Transmission_Reduced;

--Results: 181,464


--(3) Create final tables - 2 transmissions for each parent, 2 pulsations for each parent

--(3.1) Separate lat1/lon2 and lat2/lon2

--lat1/lon1

DROP TABLE IF EXISTS Gen_7165181_Rejoin_to_merge1 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_to_merge1
FROM Gen_7165181_Rejoin_Transmission_Reduced;

ALTER TABLE Gen_7165181_Rejoin_to_merge1
DROP COLUMN lon2,
DROP COLUMN lat2
RESTRICT;

--lat2/lon2

DROP TABLE IF EXISTS Gen_7165181_Rejoin_to_merge2 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_to_merge2
FROM Gen_7165181_Rejoin_Transmission_Reduced;

ALTER TABLE Gen_7165181_Rejoin_to_merge2
DROP COLUMN lon1,
DROP COLUMN lat1
RESTRICT;

--(3.2) Add columns to transmission tables and rename, delete nulls,
--parents not from italy, and rows outside date range, and drop extraneous columns

--Add columns to Children_7165181_to_merge

ALTER TABLE Gen_7165181_Rejoin_to_merge1
ADD pulse integer,
ADD type character varying(250);

UPDATE Gen_7165181_Rejoin_to_merge1 SET type = 'Transmission';
UPDATE Gen_7165181_Rejoin_to_merge1 SET pulse = 1;

--Add columns to Children_7165181_to_merge

ALTER TABLE Gen_7165181_Rejoin_to_merge2
ADD pulse integer,
ADD type character varying(250);

UPDATE Gen_7165181_Rejoin_to_merge2 SET type = 'Transmission';
UPDATE Gen_7165181_Rejoin_to_merge2 SET pulse = 1;

--Rename columns

ALTER TABLE Gen_7165181_Rejoin_to_merge1 RENAME COLUMN lat1 TO lat;
ALTER TABLE Gen_7165181_Rejoin_to_merge1 RENAME COLUMN lon1 TO lon;
ALTER TABLE Gen_7165181_Rejoin_to_merge2 RENAME COLUMN lat2 TO lat;
ALTER TABLE Gen_7165181_Rejoin_to_merge2 RENAME COLUMN lon2 TO lon;

--Eliminate nulls

DELETE FROM Gen_7165181_Rejoin_to_merge1
WHERE lat IS NULL;

DELETE FROM Gen_7165181_Rejoin_to_merge2
WHERE lat IS NULL;

--Delete everything not between 1600-2010

DELETE FROM Children_7165181_to_merge
WHERE byear < 1600
OR byear > 2010;

DELETE FROM Children_7165181_to_merge
WHERE byear < 1600
OR byear > 2010;

--Drop Extraneous columns

ALTER TABLE Gen_7165181_Rejoin_to_merge1
DROP COLUMN country_1,
DROP COLUMN country_2
RESTRICT;

ALTER TABLE Gen_7165181_Rejoin_to_merge2
DROP COLUMN country_1,
DROP COLUMN country_2
RESTRICT;


--(4) Create pulsations tables

--Create tables of transmissions to join to pulsations

--Prepare table of just IDs from transmission table for parent 1

DROP TABLE IF EXISTS Gen_7165181_Rejoin_for_joining_1 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_for_joining_1
FROM Gen_7165181_Rejoin_to_merge1;

ALTER TABLE Gen_7165181_Rejoin_for_joining_1
DROP COLUMN byear,
DROP COLUMN start_date,
DROP COLUMN end_date,
DROP COLUMN lat,
DROP COLUMN lon,
DROP COLUMN pulse,
DROP COLUMN type
RESTRICT;

--Prepare table of just IDs from transmission table for parent 2

DROP TABLE IF EXISTS Gen_7165181_Rejoin_for_joining_2 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_for_joining_2
FROM Gen_7165181_Rejoin_to_merge2;

ALTER TABLE Gen_7165181_Rejoin_for_joining_2
DROP COLUMN byear,
DROP COLUMN start_date,
DROP COLUMN end_date,
DROP COLUMN lat,
DROP COLUMN lon,
DROP COLUMN pulse,
DROP COLUMN type
RESTRICT;

--Add temp number to joining ids table for parent 1 (can't remember why this is being done, but just do it)

ALTER TABLE Gen_7165181_Rejoin_for_joining_1
ADD Temp integer;

UPDATE Gen_7165181_Rejoin_for_joining_1
SET Temp = 1;

--Add temp number to joining ids table for parent 2

ALTER TABLE Gen_7165181_Rejoin_for_joining_2
ADD Temp integer;

UPDATE Gen_7165181_Rejoin_for_joining_2
SET Temp = 1;


--Join tables to pulsation table to create Gen_7165181_Rejoin_pulsation tables

--Apparently there are sequence columns obstructing joining
ALTER TABLE Gen_7165181_Rejoin_for_joining_1
DROP COLUMN sequence
RESTRICT;

ALTER TABLE Gen_7165181_Rejoin_for_joining_2
DROP COLUMN sequence
RESTRICT;

--Table 1
DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_1 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_pulsation_1
FROM Gen_7165181_Rejoin_for_joining_1 G
JOIN pulsation P using (Id);

--Table 2
DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_2 CASCADE;
SELECT * INTO Gen_7165181_Rejoin_pulsation_2
FROM Gen_7165181_Rejoin_for_joining_2 G
JOIN pulsation P using (Id);


--Add proper end date to Pulsation tables

--Create temp columns

--For table 1
ALTER TABLE Gen_7165181_Rejoin_pulsation_1
ADD temp2 character varying(250);

UPDATE Gen_7165181_Rejoin_pulsation_1 SET temp2 = RIGHT(start_date,2);

--For table 2
ALTER TABLE Gen_7165181_Rejoin_pulsation_2
ADD temp2 character varying(250);

UPDATE Gen_7165181_Rejoin_pulsation_2 SET temp2 = RIGHT(start_date,2);

--Find out what min and max are:

SELECT MIN(byear), MAX(byear) max FROM Gen_7165181_Rejoin_pulsation_1;
SELECT MIN(byear), MAX(byear) max FROM Gen_7165181_Rejoin_pulsation_2;

--Change end_date accordingly
UPDATE Gen_7165181_Rejoin_pulsation_1 SET End_Date = '1914-12'
WHERE temp2 = '11';

UPDATE Gen_7165181_Rejoin_pulsation_2 SET End_Date = '1914-12'
WHERE temp2 = '11';


--Delete extraneous columns and nulls

ALTER TABLE Gen_7165181_Rejoin_pulsation_1
DROP COLUMN temp,
DROP COLUMN temp2,
DROP COLUMN sequence
RESTRICT;

ALTER TABLE Gen_7165181_Rejoin_pulsation_2
DROP COLUMN temp,
DROP COLUMN temp2,
DROP COLUMN sequence
RESTRICT;

--Delete any nulls
DELETE FROM Gen_7165181_Rejoin_pulsation_1
WHERE lat IS NULL;

DELETE FROM Gen_7165181_Rejoin_pulsation_2
WHERE lat IS NULL;


--Reduce resulting pulsations tables

DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_1_Reduced CASCADE;
CREATE TABLE Gen_7165181_Rejoin_pulsation_1_Reduced AS (
    SELECT lon, lat, byear, pulse, type, start_date, end_date, max(id) FROM Gen_7165181_Rejoin_pulsation_1 GROUP BY lon, lat, byear, pulse, type, start_date, end_date
);

ALTER TABLE Gen_7165181_Rejoin_pulsation_1_Reduced RENAME COLUMN max TO id;

DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_2_Reduced CASCADE;
CREATE TABLE Gen_7165181_Rejoin_pulsation_2_Reduced AS (
    SELECT lon, lat, byear, pulse, type, start_date, end_date, max(id) FROM Gen_7165181_Rejoin_pulsation_2 GROUP BY lon, lat, byear, pulse, type, start_date, end_date
);

ALTER TABLE Gen_7165181_Rejoin_pulsation_2_Reduced RENAME COLUMN max TO id;


--Drop tables and rename to original

--Drop Tables
DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_2 CASCADE;
DROP TABLE IF EXISTS Gen_7165181_Rejoin_pulsation_1 CASCADE;

--Rename Tables
ALTER TABLE Gen_7165181_Rejoin_pulsation_1_Reduced
RENAME TO Gen_7165181_Rejoin_pulsation_1;

ALTER TABLE Gen_7165181_Rejoin_pulsation_2_Reduced
RENAME TO Gen_7165181_Rejoin_pulsation_2;

/*

--Merge pulsation and transmission (not working, skip for now)

select * from gen1_to_merge
union
select * from gen2_to_merge
INTO transmission_joined;

*/

--Export 7165181 parent
DROP TABLE IF EXISTS Parent_7165181 CASCADE;
SELECT * INTO Parent_7165181
FROM Gen
WHERE id = 7165181;

ALTER TABLE Parent_7165181
DROP COLUMN sequence,
DROP COLUMN id_2,
DROP COLUMN lon_2,
DROP COLUMN lat_2,
DROP COLUMN country_2,
DROP COLUMN continent_2,
DROP COLUMN res_2,
DROP COLUMN byear_2,
DROP COLUMN dyear_2,
DROP COLUMN idx_2,
DROP COLUMN parent_id_2,
DROP COLUMN id_1,
DROP COLUMN lon_1,
DROP COLUMN lat_1,
DROP COLUMN country_1,
DROP COLUMN continent_1,
DROP COLUMN res_1,
DROP COLUMN byear_1,
DROP COLUMN dyear_1,
DROP COLUMN idx_1,
DROP COLUMN parent_id_1,
DROP COLUMN country,
DROP COLUMN continent,
DROP COLUMN res,
--DROP COLUMN byear,
DROP COLUMN dyear,
DROP COLUMN gender,
DROP COLUMN late_yr,
DROP COLUMN diff,
DROP COLUMN tot_mo
--DROP COLUMN lon,
--DROP COLUMN lat
RESTRICT;


-- Create csv file
COPY Gen_7165181_Rejoin_pulsation_1 TO 'D:\Gen_7165181_Rejoin_pulsation_1.csv' DELIMITER ',' CSV HEADER;

-- Create csv file
COPY Gen_7165181_Rejoin_pulsation_2 TO 'D:\Gen_7165181_Rejoin_pulsation_2.csv' DELIMITER ',' CSV HEADER;

-- Create csv file
COPY Gen_7165181_Rejoin_to_merge1 TO 'D:\Gen_7165181_Rejoin_to_merge1.csv' DELIMITER ',' CSV HEADER;

-- Create csv file
COPY Gen_7165181_Rejoin_to_merge2 TO 'D:\Gen_7165181_Rejoin_to_merge2.csv' DELIMITER ',' CSV HEADER;

-- Create csv file
COPY Parent_7165181 TO 'D:\Parent_7165181.csv' DELIMITER ',' CSV HEADER;









--Additional, delete or move
--Reduce resulting pulsations tables

DROP TABLE IF EXISTS Parents_Children_7165181_to_merge1_Reduced CASCADE;
CREATE TABLE Parents_Children_7165181_to_merge1_Reduced AS (
    SELECT lon, lat, byear, pulse, type, start_date, end_date, max(id) FROM Gen_7165181_Rejoin_to_merge1 GROUP BY lon, lat, byear, pulse, type, start_date, end_date
);

ALTER TABLE Parents_Children_7165181_to_merge1_Reduced RENAME COLUMN max TO id;

SELECT COUNT(*) FROM Parents_Children_7165181_to_merge1_Reduced;

177,125
Results: 181,464

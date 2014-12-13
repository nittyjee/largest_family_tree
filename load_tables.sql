-- Create and load tables

-- Age
DROP TABLE IF EXISTS age CASCADE;

CREATE TABLE age
(
Id integer,
Age integer
);

copy age from 'D:\largest_family_tree\Data\Geneology_CSV\age.csv' delimiter as ',' csv header;


-- Founders
DROP TABLE IF EXISTS founders CASCADE;

CREATE TABLE founders
(
Founder integer,
Nleaves integer,
MinG integer,
MaxG integer,
MedianG float
);

copy founders from 'D:\largest_family_tree\Data\Geneology_CSV\founders.csv' delimiter as ',' csv header;

-- Gender
DROP TABLE IF EXISTS gender CASCADE;

CREATE TABLE gender
(
Id integer,
Gender integer
);

copy gender from 'D:\largest_family_tree\Data\Geneology_CSV\gender.csv' delimiter as ',' csv header;

-- Location
-- Location table had a bad row that needed to be deleted
-- Can't remember why, but first loaded temp table, deleted row,
-- then exported it and reimported it as a new tableand deleted the old table.

-- Load location table for row deletion

DROP TABLE IF EXISTS location_temp CASCADE;

CREATE TABLE location_temp
(
Id integer,
Lon character varying(250),
Lat character varying(250),
Country character varying(250),
Continent character varying(250),
Res character varying(250)
);

copy location_temp from 'D:\largest_family_tree\Data\Geneology_CSV\location.csv' delimiter as ',' csv header;

--Delete problem row (last row)

DELETE FROM location_temp
WHERE id = 0;

-- Export to CSV file
COPY location_temp TO 'D:\largest_family_tree\Data\Geneology_CSV\location_scrub.csv' DELIMITER ',' CSV HEADER;

-- Location
DROP TABLE IF EXISTS location CASCADE;

CREATE TABLE location
(
Id integer,
Lon FLOAT,
Lat FLOAT,
Country character varying(250),
Continent character varying(250),
Res character varying(250)
);

copy location from 'D:\largest_family_tree\Data\Geneology_CSV\location_scrub.csv' delimiter as ',' csv header;

--Delete location_temp table
DROP TABLE IF EXISTS location_temp CASCADE;


-- Relationship
DROP TABLE IF EXISTS relationship CASCADE;

CREATE TABLE relationship
(
Idx integer,
Child_id integer,
Parent_id integer
);

copy relationship from 'D:\largest_family_tree\Data\Geneology_CSV\relationship.csv' delimiter as ',' csv header;

-- Years
DROP TABLE IF EXISTS age CASCADE;

CREATE TABLE years
(
Id integer,
Byear integer,
Dyear integer
);

copy years from 'D:\largest_family_tree\Data\Geneology_CSV\years.csv' delimiter as ',' csv header;





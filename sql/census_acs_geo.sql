CREATE EXTERNAL TABLE `census_acs_geo`(
  `geoid` string,
  `name` string,
  `state_fips` string,
  `county_fips` string,
  `tract_code` string,
  `block_group_code` string,
  `land_area` string,
  `water_area` string,
  `wkt` string)
PARTITIONED BY ( 
  `level` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES ( 
  'quoteChar'='\"', 
  'separatorChar'=',') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://cortico-data/census/acs/geo'
TBLPROPERTIES (
  'compressionType'='none', 
  'skip.header.line.count'='1')


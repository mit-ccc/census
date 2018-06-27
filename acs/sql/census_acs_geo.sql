drop table if exists cortico.census_acs_geo;
create external table cortico.census_acs_geo (
  geoid string,
  name string,
  state_fips string,
  county_fips string,
  tract_code string,
  block_group_code string,
  land_area string,
  water_area string,
  wkt string)
partitioned by ( 
  level string)
row format serde 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
with serdeproperties ( 
  'quoteChar'='\"', 
  'separatorChar'=',') 
stored as inputformat 
  'org.apache.hadoop.mapred.TextInputFormat' 
outputformat 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location
  's3://cortico-data/census/acs/geo'
tblproperties (
  'compressionType'='none', 
  'skip.header.line.count'='1')


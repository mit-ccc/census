drop table if exists cortico.census_acs_data;
create external table cortico.census_acs_data (
  geoid string,
  variable string,
  value string)
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
  's3://cortico-data/census/acs/data'
tblproperties (
  'compressionType'='none', 
  'skip.header.line.count'='1')


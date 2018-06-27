drop table if exists cortico.census_acs_variable;
create external table cortico.census_acs_variable (
  variable string,
  description string)
row format serde 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
with serdeproperties ( 
  'separatorChar'=',') 
stored as inputformat 
  'org.apache.hadoop.mapred.TextInputFormat' 
outputformat 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location
  's3://cortico-data/census/acs/variables'
tblproperties (
  'compressionType'='none', 
  'skip.header.line.count'='1')


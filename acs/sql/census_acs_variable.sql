CREATE EXTERNAL TABLE `cortico.census_acs_variable`(
  `variable` string,
  `description` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES ( 
  'separatorChar'=',') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://cortico-data/census/acs/variables'
TBLPROPERTIES (
  'compressionType'='none', 
  'skip.header.line.count'='1')


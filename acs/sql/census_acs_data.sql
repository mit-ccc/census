CREATE EXTERNAL TABLE `cortico.census_acs_data`(
  `geoid` string,
  `variable` string,
  `value` string)
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
  's3://cortico-data/census/acs/data'
TBLPROPERTIES (
  'compressionType'='none', 
  'skip.header.line.count'='1')


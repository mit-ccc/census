#!/bin/bash

set -e

SOURCE='ftp://ftp2.census.gov/geo/tiger/TIGER_DP/2016ACS'
TARGET='s3://cortico-data/census/acs'
AWS_PROFILE='cortico'

wget -P ./raw/gdb/ "$SOURCE/ACS_2016_5YR_STATE.gdb.zip"
wget -P ./raw/gdb/ "$SOURCE/ACS_2016_5YR_COUNTY.gdb.zip"
wget -P ./raw/gdb/ "$SOURCE/ACS_2016_5YR_TRACT.gdb.zip"
wget -P ./raw/gdb/ "$SOURCE/ACS_2016_5YR_ZCTA.gdb.zip"
wget -P ./raw/gdb/ "$SOURCE/ACS_2016_5YR_BG.gdb.zip"

cd raw/
mkdir -p geo state county zcta tract bg

# extract geojson geographies
ogr2ogr -f geojson geo/state.json gdb/ACS_2016_5YR_STATE.gdb.zip ACS_2016_5YR_STATE
ogr2ogr -f geojson geo/county.json gdb/ACS_2016_5YR_COUNTY.gdb.zip ACS_2016_5YR_COUNTY
ogr2ogr -f geojson geo/zcta.json gdb/ACS_2016_5YR_ZCTA.gdb.zip ACS_2016_5YR_ZCTA
ogr2ogr -f geojson geo/tract.json gdb/ACS_2016_5YR_TRACT.gdb.zip ACS_2016_5YR_TRACT
ogr2ogr -f geojson geo/bg.json gdb/ACS_2016_5YR_BG.gdb.zip ACS_2016_5YR_BG

# extract data
ogr2ogr -overwrite -f csv state/ ACS_2016_5YR_STATE.gdb.zip
ogr2ogr -overwrite -f csv county/ ACS_2016_5YR_COUNTY.gdb.zip
ogr2ogr -overwrite -f csv zcta/ ACS_2016_5YR_ZCTA.gdb.zip
ogr2ogr -overwrite -f csv tract/ ACS_2016_5YR_TRACT.gdb.zip
ogr2ogr -overwrite -f csv bg/ ACS_2016_5YR_BG.gdb.zip

# load all raw data to S3 for archiving/reproducibility
aws s3 cp --recursive --profile="$AWS_PROFILE" . "$TARGET/raw/"

# drop some files we don't need
rm state/ACS_2016_5YR_STATE.csv
rm county/ACS_2016_5YR_COUNTY.csv
rm zcta/ACS_2016_5YR_ZCTA.csv
rm tract/ACS_2016_5YR_TRACT.csv
rm bg/ACS_2016_5YR_BG.csv

# handle metadata
echo "variable,description" > variables.csv
tail -n +2 {state,county,zcta,tract,bg}/*METADATA* | sort | uniq >> variables.csv
aws s3 cp --profile="$AWS_PROFILE" variables.csv "$TARGET/variables/"
rm {state,county,zcta,tract,bg}/*METADATA*
rm variables.csv

# process data
bin/pivot.py state/* | gzip > state_data.csv.gz
aws s3 cp --profile="$AWS_PROFILE" state_data.csv.gz "$TARGET/data/level=state/"
rm state_data.csv.gz

bin/pivot.py county/* | gzip > county_data.csv.gz
aws s3 cp --profile="$AWS_PROFILE" county_data.csv.gz "$TARGET/data/level=county/"
rm county_data.csv.gz

bin/pivot.py zcta/* | gzip > zcta_data.csv.gz
aws s3 cp --profile="$AWS_PROFILE" zcta_data.csv.gz "$TARGET/data/level=zcta/"
rm zcta_data.csv.gz

bin/pivot.py tract/* | gzip > tract_data.csv.gz
aws s3 cp --profile="$AWS_PROFILE" tract_data.csv.gz "$TARGET/data/level=tract/"
rm tract_data.csv.gz

bin/pivot.py bg/* | gzip > bg_data.csv.gz
aws s3 cp --profile="$AWS_PROFILE" bg_data.csv.gz "$TARGET/data/level=bg/"
rm bg_data.csv.gz

# convert geographies to csv
ogr2ogr -f csv -lco GEOMETRY=AS_WKT state.csv geo/state.json
ogr2ogr -f csv -lco GEOMETRY=AS_WKT county.csv geo/county.json
ogr2ogr -f csv -lco GEOMETRY=AS_WKT zcta.csv geo/zcta.json
ogr2ogr -f csv -lco GEOMETRY=AS_WKT tract.csv geo/tract.json
ogr2ogr -f csv -lco GEOMETRY=AS_WKT bg.csv geo/bg.json

# process geographies


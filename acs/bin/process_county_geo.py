#!/usr/bin/env python3

import sys
import re
import pandas as pd

column_order = ['geoid', 'name', 'state_fips', 'county_fips', 'tract_code',
                'block_group_code', 'land_area', 'water_area', 'wkt']

county = pd.read_csv(sys.argv[1])

county.columns = county.columns.str.lower()
county = county.drop(['countyns', 'geoid', 'name', 'lsad', 'classfp', 'mtfcc', 'csafp', 'cbsafp',
                      'metdivfp', 'funcstat', 'intptlat', 'intptlon', 'shape_length', 'shape_area'], axis=1)

county.columns = ['wkt', 'state_fips', 'county_fips', 'name', 'land_area', 'water_area', 'geoid']

county['tract_code'] = ''
county['block_group_code'] = ''

county = county[column_order]

county['state_fips'] = county['state_fips'].astype(str).replace(re.compile('\.0$'), '')
county['state_fips'] = county['state_fips'].replace('nan', '')
county['state_fips'] = county['state_fips'].str.pad(2, 'left', '0')

county['county_fips'] = county['county_fips'].astype(str).replace(re.compile('\.0$'), '')
county['county_fips'] = county['county_fips'].replace('nan', '')
county['county_fips'] = county['county_fips'].str.pad(3, 'left', '0')

county.to_csv(sys.argv[1], index=False)


#!/usr/bin/env python3

import sys
import re
import pandas as pd

column_order = ['geoid', 'name', 'state_fips', 'county_fips', 'tract_code',
                'block_group_code', 'land_area', 'water_area', 'wkt']

tract = pd.read_csv(sys.argv[1])

tract.columns = tract.columns.str.lower()

tract = tract.drop(['geoid', 'name', 'mtfcc', 'funcstat', 'intptlat',
                   'intptlon', 'shape_length', 'shape_area'], axis=1)

tract.columns = ['wkt', 'state_fips', 'county_fips', 'tract_code', 'name', 'land_area', 'water_area', 'geoid']

tract['block_group_code'] = ''

tract = tract[column_order]

tract['state_fips'] = tract['state_fips'].astype(str).replace(re.compile('\.0$'), '')
tract['state_fips'] = tract['state_fips'].replace('nan', '')
tract['state_fips'] = tract['state_fips'].str.pad(2, 'left', '0')

tract['county_fips'] = tract['county_fips'].astype(str).replace(re.compile('\.0$'), '')
tract['county_fips'] = tract['county_fips'].replace('nan', '')
tract['county_fips'] = tract['county_fips'].str.pad(3, 'left', '0')

tract['tract_code'] = tract['tract_code'] / 100.0
tract['tract_code'] = tract['tract_code'].astype(str).replace(re.compile('\.0$'), '')
tract['tract_code'] = tract['tract_code'].replace('nan', '')

tract.to_csv(sys.argv[1], index=False)


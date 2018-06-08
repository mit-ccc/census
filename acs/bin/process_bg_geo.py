#!/usr/bin/env python3

import sys
import re
import pandas as pd

column_order = ['geoid', 'name', 'state_fips', 'county_fips', 'tract_code',
                'block_group_code', 'land_area', 'water_area', 'wkt']

bg = pd.read_csv(sys.argv[1])

bg.columns = bg.columns.str.lower()

bg = bg.drop(['geoid', 'mtfcc', 'funcstat', 'intptlat',
                   'intptlon', 'shape_length', 'shape_area'], axis=1)

bg.columns = ['wkt', 'state_fips', 'county_fips', 'tract_code', 'block_group_code',
              'name', 'land_area', 'water_area', 'geoid']

bg = bg[column_order]

bg['state_fips'] = bg['state_fips'].astype(str).replace(re.compile('\.0$'), '')
bg['state_fips'] = bg['state_fips'].replace('nan', '')
bg['state_fips'] = bg['state_fips'].str.pad(2, 'left', '0')

bg['county_fips'] = bg['county_fips'].astype(str).replace(re.compile('\.0$'), '')
bg['county_fips'] = bg['county_fips'].replace('nan', '')
bg['county_fips'] = bg['county_fips'].str.pad(3, 'left', '0')

bg['tract_code'] = bg['tract_code'] / 100.0
bg['tract_code'] = bg['tract_code'].astype(str).replace(re.compile('\.0$'), '')
bg['tract_code'] = bg['tract_code'].replace('nan', '')

bg['block_group_code'] = bg['block_group_code'].astype(str).replace(re.compile('\.0$'), '')
bg['block_group_code'] = bg['block_group_code'].replace('nan', '')

bg.to_csv(sys.argv[2], index=False)


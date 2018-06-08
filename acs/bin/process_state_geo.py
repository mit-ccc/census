#!/usr/bin/env python3

import sys
import re
import pandas as pd

column_order = ['geoid', 'name', 'state_fips', 'county_fips', 'tract_code',
                'block_group_code', 'land_area', 'water_area', 'wkt']

state = pd.read_csv(sys.argv[1])

state.columns = state.columns.str.lower()
state = state.drop(['region', 'division', 'statens', 'geoid', 'stusps', 'lsad', 'mtfcc',
                    'funcstat', 'intptlat', 'intptlon', 'shape_length', 'shape_area'], axis=1)

state.columns = ['wkt', 'state_fips', 'name', 'land_area', 'water_area', 'geoid']

state['county_fips'] = ''
state['tract_code'] = ''
state['block_group_code'] = ''

state = state[column_order]

state['state_fips'] = state['state_fips'].astype(str).replace(re.compile('\.0$'), '')
state['state_fips'] = state['state_fips'].replace('nan', '')
state['state_fips'] = state['state_fips'].str.pad(2, 'left', '0')

state.to_csv(sys.argv[1], index=False)


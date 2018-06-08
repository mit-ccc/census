#!/usr/bin/env python3

import sys
import pandas as pd

column_order = ['geoid', 'name', 'state_fips', 'county_fips', 'tract_code',
                'block_group_code', 'land_area', 'water_area', 'wkt']

zcta = pd.read_csv(sys.argv[1])

zcta.columns = zcta.columns.str.lower()
zcta = zcta.drop(['geoid10', 'classfp10', 'mtfcc10', 'funcstat10', 'intptlat10',
                  'intptlon10', 'shape_length', 'shape_area'], axis=1)

zcta.columns = ['wkt', 'name', 'land_area', 'water_area', 'geoid']

zcta['name'] = zcta.name.astype(str)
zcta['name'] = 'ZIP ' + zcta.name

zcta['state_fips'] = ''
zcta['county_fips'] = ''
zcta['tract_code'] = ''
zcta['block_group_code'] = ''

zcta = zcta[column_order]

zcta.to_csv(sys.argv[2], index=False)


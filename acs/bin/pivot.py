#!/usr/bin/env python3

import sys
import csv

out = csv.writer(sys.stdout)
out.writerow(['geoid', 'variable', 'value'])

for f in sys.argv[1:]:
    # progress tracking
    sys.stderr.write(f)
    sys.stderr.write('\n')
    sys.stderr.flush()
    
    reader = csv.DictReader(open(f, 'r'))

    for row in reader:
        geoid = row['GEOID']
        keys = list(set(row.keys()) - set(['GEOID']))

        for k in keys:
            out.writerow([geoid, k, row[k]])



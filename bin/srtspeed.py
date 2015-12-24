#!/usr/bin/env python
"""
speed.py <factor> files...

Divide by <factor> all times in input files.
Change files in-place, or stdin to stdout if files not given.
"""

from __future__ import division

import sys, re, fileinput

TIME_RE = re.compile(r'([+-]?[0-9]+):([0-9]+):([0-9]+)(?:[.,][0-9]*)?')

def time2secs(match):
    h, m, s = map(float, match.groups())
    return 3600 * h + 60 * m + s

def secs2time(secs):
    mins, s = divmod(secs, 60)
    h, m = divmod(mins, 60)
    return '%02d:%02d:%06.3f' % (h, m, s)

def main(factor, input):
    def div(match):
        return secs2time(time2secs(match) / factor)
    for line in input:
        sys.stdout.write(TIME_RE.sub(div, line))

if __name__ == '__main__':
    try:
        factor = float(sys.argv.pop(1))
    except:
        print __doc__
        sys.exit(2)
    main(factor, fileinput.input(inplace=True))

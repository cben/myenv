#!/usr/bin/env python
"""
srtdelay.py [+-]hh:mm:ss[.sss] files...

Adds given time to all times in input files (to stdout).
"""

import sys, re, fileinput

TIME_RE = re.compile(r'([+-]?)([0-9]+):([0-9]+):([0-9]+)(?:[.,][0-9]*)?')

def time2secs(match):
    groups = match.groups()
    sign = groups[0]
    h, m, s = [float(sign + g) for g in groups[1:]]
    return 3600 * h + 60 * m + s

def secs2time(secs):
    mins, s = divmod(secs, 60)
    h, m = divmod(mins, 60)
    return '%02d:%02d:%06.3f' % (h, m, s)

def main(delay, input):
    def add(match):
        return secs2time(time2secs(match) + delay)
    for line in input:
        sys.stdout.write(TIME_RE.sub(add, line))

if __name__ == '__main__':
    try:
        t = time2secs(TIME_RE.match(sys.argv.pop(1)))
    except:
        print __doc__
        sys.exit(2)
    main(t, fileinput.input())

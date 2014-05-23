#!/bin/bash
# For some reason, 2490WUXi reports 720p instead of 1080p when HDCP is enabled.

if $(dirname $0)/xrandr-edid.sh | grep -q "2490WUXi"; then
  MODE="1920x1200R"
  echo "== Detected (at least one) 2490WUXi, applying $MODE (to all outs). =="
  # /dev/null the "X Error...BadName" error if already exist.
  # Reduced blank timing (cvt -r).
  xrandr --newmode "1920x1200R"  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync  2> /dev/null
  # Regular timing.
  xrandr --newmode "1920x1200_60"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync  2> /dev/null

  for OUT in HDMI{1,2,3}; do
    if xrandr | grep -q "^$OUT connected"; then
      xrandr --addmode $OUT $MODE
      xrandr --output $OUT --mode $MODE
    fi
  done
else
  echo "== WRONG MONITOR (run $(dirname $0)/xrandr-edid.sh for details). =="
fi

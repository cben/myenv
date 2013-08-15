#!/bin/bash
if $(dirname $0)/xrandr-edid.sh | grep -q "2490WUXi"; then
  xrandr --newmode   "1920x1200R"  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync
  for OUT in HDMI2 HDMI3; do
    xrandr --addmode $OUT "1920x1200R"
    xrandr --output $OUT --mode "1920x1200R"
  done
else
  echo "WRONG MONITOR (run $(dirname $0)/xrandr-edid.sh for details)."
fi

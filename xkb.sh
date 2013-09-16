#!/bin/bash
setxkbmap -layout us,us,il,ru \
  -variant mac,colemak,lyx,phonetic \
  -option '' \
  -option grp:shift_caps_toggle,grp:alt_shift_toggle,grp:sclk_toggle,grp_led:scroll,lv3:rwin_switch,keypad:oss,caps:backspace
# TODO: lv3:rwin_switch might not work on all kbds?

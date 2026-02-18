#!/bin/bash

sketchybar --add item apple left \
  --set apple \
  icon="$ICON_APPLE" \
  icon.font="SF Pro:Black:16.0" \
  icon.color=$LAVENDER \
  label.drawing=off \
  background.color=$TRANSPARENT \
  background.padding_left=8 \
  background.padding_right=8 \
  click_script="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add item apple.about popup.apple \
  --set apple.about \
  icon="$ICON_INFO" \
  label="About This Mac" \
  click_script="open 'x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension'; sketchybar --set apple popup.drawing=off"

sketchybar --add item apple.
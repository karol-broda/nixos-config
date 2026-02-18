#!/bin/bash

trigger_sketchybar_event() {
  local event_name="$1"
  sketchybar --trigger "$event_name" &>/dev/null
}

get_focused_workspace() {
  aerospace list-workspaces --focused 2>/dev/null | tr -d '[:space:]'
}

get_visible_workspaces() {
  aerospace list-workspaces --monitor all --visible 2>/dev/null
}

case "${1:-workspace_change}" in
  workspace_change)
    FOCUSED_WORKSPACE=$(get_focused_workspace)
    trigger_sketchybar_event "aerospace_workspace_change"
    ;;

  window_change)
    trigger_sketchybar_event "space_windows_change"
    ;;

  focus_change)
    trigger_sketchybar_event "front_app_switched"
    ;;

  *)
    trigger_sketchybar_event "aerospace_workspace_change"
    trigger_sketchybar_event "space_windows_change"
    ;;
esac

exit 0

#!/usr/bin/env bash
# Author: Omri Levy Shahar
# TODO: add support for a directory of premade presets (.screenlayout)

refresh_wm() {
  herbstclient detect_monitors
}

menu_cmd() {
  rofi -dmenu -i
}

set_resolution() {
  monitor="$1"
  modes="$(xrandr | tr '\n' ' ' | grep -hoe "$monitor.\+" | grep -hoPe "\d+x\d+ ")"
  chosen_mode=$(echo -e "Auto\n${modes[@]}\nBack\nExit" | menu_cmd)
  if [ "$chosen_mode" == "Exit" ]; then
    exit
  elif [ "$chosen_mode" != "Back" ]; then
    if [ "$chosen_mode" == "Auto" ]; then
      xrandr --output "$monitor" --auto
    else
      xrandr --output "$monitor" --mode "$chosen_mode"
    fi
  fi
}

set_position() {
  monitor="$1"
  positions="Above"
  positions+="\nBelow"
  positions+="\nLeft of"
  positions+="\nRight of"
  positions+="\nBack"
  chosen_position=$(echo -e "${positions[@]}" | menu_cmd)
  if [ "$chosen_position" == "Exit" ]; then
    exit
  elif [ "$chosen_mode" != "Back" ]; then
    while true; do
      relative_monitor=$(echo "${monitors[@]} Back Exit" | tr ' ' '\n' | menu_cmd)
      if [ "$relative_monitor" != "$monitor" ]; then
        break
      fi
    done

    if [ "$relative_monitor" == "Exit" ]; then
      exit
    elif [ "$relative_monitor" == "Back" ]; then
      set_position "$chosen_monitor"
    else
      case "$chosen_position" in
        "Above")
          xrandr_switch="--above"
          ;;
        "Below")
          xrandr_switch="--below"
          ;;
        "Left of")
          xrandr_switch="--left-of"
          ;;
        "Right of")
          xrandr_switch="--right-of"
          ;;
      esac
      xrandr --output "$chosen_monitor" "$xrandr_switch" "$relative_monitor"
    fi
  fi
}

monitors="$(xrandr | grep -hoPe "[a-zA-Z]+[0-9-]+ connected" | grep -hoPe "[a-zA-Z]+[0-9-]+")"
monitors=($monitors)
menu="Make primary"
menu+="\nSet resolution"
if [ ${#monitors[@]} -ne 1 ]; then
  menu+="\nSet position"
fi
menu+="\nBack"
menu+="\nExit"

while true; do
  chosen_monitor=$(echo "${monitors[@]} Exit" | tr ' ' '\n' | menu_cmd)
  if [ "$chosen_monitor" == "Exit" ]; then
    exit
  fi

  chosen_menu=$(echo -e "${menu[@]}" | menu_cmd)
  case "$chosen_menu" in
    "Make primary")
      xrandr --output "$chosen_monitor" --primary 
      ;;
    "Set resolution")
      set_resolution "$chosen_monitor"
      ;;
    "Set position")
      set_position "$chosen_monitor"
      ;;
    "Exit")
      exit
      ;;
    "Back")
      ;;
  esac
  refresh_wm
done

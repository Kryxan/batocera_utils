#!/bin/bash

# need to set these key bindings
# KEY_VOLUMEUP 1 /userdata/system/scripts/osd-control.sh volume up
# KEY_VOLUMEDOWN 1 /userdata/system/scripts/osd-control.sh volume down
# KEY_MUTE 1 /userdata/system/scripts/osd-control.sh volume toggle
# KEY_BRIGHTNESSUP 1 /userdata/system/scripts/osd-control.sh brightness up
# KEY_BRIGHTNESSDOWN 1 /userdata/system/scripts/osd-control.sh brightness down

TYPE=$1      # volume or brightness
ACTION=$2    # up, down, toggle
THEME=$3     # neon, retro, minimal

# === Theme Presets === doesn't work
case "$THEME" in
  neon)
    FG="#00FFFF"
    BG="#000000"
    ICON="audio-volume-high"
    ;;
  retro)
    FG="#FFD700"
    BG="#2F4F4F"
    ICON="media-playback-start"
    ;;
  minimal)
    FG="#FFFFFF"
    BG="#1e1e1e"
    ICON="display-brightness"
    ;;
  *)
    FG="#FFFFFF"
    BG="#1e1e1e"
    ICON="display-brightness"
    ;;
esac

# === Dimensions and Positioning ===
WINDOW_WIDTH=400
BAR_HEIGHT=10
MARGIN=20
POSITION="top"  # or "bottom"

SCREEN_WIDTH=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f1)
SCREEN_HEIGHT=$(xrandr | grep '*' | awk '{print $1}' | cut -d'x' -f2)

if [ "$POSITION" = "top" ]; then
  Y_POS=$MARGIN
else
  Y_POS=$((SCREEN_HEIGHT - BAR_HEIGHT - MARGIN))
fi
X_POS=$(( (SCREEN_WIDTH - WINDOW_WIDTH) / 2 ))

# === Show OSD
show_osd() {
  local label=$1
  local value=$2

yad --scale \
  --value=$value \
  --min-value=0 \
  --max-value=100 \
  --title="$label" \
  --no-buttons \
  --auto-close \
  --undecorated \
  --skip-taskbar \
  --text="" \
    --geometry=${WINDOW_WIDTH}x${BAR_HEIGHT}+$X_POS+$Y_POS \
    --window-icon="$ICON" \
    --timeout=1 \
    --foreground="$FG" \
    --background="$BG" &


# echo "$label: $value" | osd_cat -f -*-*-bold-*-*-*-38-120-*-*-*-*-*-* -cred -s 3 -d 2 &


}

# === Adjust Volume
adjust_volume() {
  current=$(batocera-audio getSystemVolume)
  case $ACTION in
    up) new=$((current + 5)); [ "$new" -gt 100 ] && new=100 ;;
    down) new=$((current - 5)); [ "$new" -lt 0 ] && new=0 ;;
    toggle) batocera-audio setSystemVolume mute-toggle; return ;;
    *) new=$current ;;
  esac
  batocera-audio setSystemVolume "$new"
  show_osd "Volume" "$new"
}

# === Adjust Brightness
adjust_brightness() {
  current=$(batocera-brightness)
  case $ACTION in
    up) new=$((current + 10)); [ "$new" -gt 100 ] && new=100 ;;
    down) new=$((current - 10)); [ "$new" -lt 1 ] && new=1 ;;
    *) new=$current ;;
  esac
  batocera-brightness "$new"
  show_osd "Brightness" "$new"
}

# === Main
case $TYPE in
  volume) adjust_volume ;;
  brightness) adjust_brightness ;;
  *) echo "Usage: $0 [volume|brightness] [up|down|toggle] [theme]" ;;
esac

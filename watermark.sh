#!/bin/bash

## default values
DATE=$(date +%d.%m.%y)
COLOR="255, 255, 255"
TR="0.4"
SIZE="600" 
BORDER=10
ROTATE=30

POSITIONAL_ARGS=()

## override from arguments if there are
while [[ $# -gt 0 ]]; do
  case $1 in
    --for)
      FOR="$2"
      shift
      shift
      ;;
    --date)
      DATE="$2"
      shift
      shift
      ;;
    --color)
      COLOR="$2"
      shift
      shift
      ;;
    --tr)
      TR="$2"
      shift
      shift
      ;;
    --size)
      SIZE="$2"
      shift
      shift
      ;;
    --border)
      BORDER="$2"
      shift
      shift
      ;;
    --rotate)
      ROTATE="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Неизвестный параметр $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift 
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "$FOR" ]; then
    echo "Не указан адресат ( параметр --for )"
    exit 1;
fi

convert $1 \
  \( \
    -size $"${SIZE}x" \
    -background none \
    -fill "rgba($COLOR, $TR)" \
    -gravity center \
    label:"Копия для $FOR\r\n$DATE" \
    -trim \
    -rotate -$ROTATE \
    -bordercolor none \
    -border $BORDER \
    -write mpr:wm \
    +delete \
    +clone \
    -fill mpr:wm  \
    -draw 'color 0,0 reset' \
  \) \
  -compose over \
  -composite \
  out_$1

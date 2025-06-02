#!/bin/bash

# 배경화면 디렉토리 설정
WALLPAPER_DIR="$HOME/wallpapers"
WALLPAPERS=($(ls "$WALLPAPER_DIR"/wallpaper*.png | sort))

# 현재 배경화면 가져오기
CURRENT_WALLPAPER=$(swww query | grep 'image' | awk '{print $8}')

# 다음 배경화면 결정
NEXT_WALLPAPER=${WALLPAPERS[0]}  # 기본값은 첫 번째 이미지
for ((i=0; i<${#WALLPAPERS[@]}; i++)); do
    if [[ "${WALLPAPERS[i]}" == "$CURRENT_WALLPAPER" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#WALLPAPERS[@]} ))
        NEXT_WALLPAPER=${WALLPAPERS[NEXT_INDEX]}
        break
    fi
done

# pywal 색상 생성
wal -i "$NEXT_WALLPAPER"

# 배경화면 변경
swww img "$NEXT_WALLPAPER"

# waybar 리로드
killall waybar && waybar & echo "Wallpaper changed to: $NEXT_WALLPAPER"


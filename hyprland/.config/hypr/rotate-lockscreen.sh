#!/usr/bin/env bash
DIR="/home/fergus/.config/hypr"

for file in $(ls $DIR/*.png | sort -r); do
  num=$(echo $file | sed 's/.*\([0-9]\)\+.png/\1/') # wall0.png -> 0
  new_num=$(echo $num | awk '{$1=$1+1;print}') # 0 -> 1

  if [[ -z $FIRST ]]; then
    FIRST=$DIR/wall$${new_num}.png
  fi

  mv $file $DIR/wall$${new_num}.png
done

mv $FIRST $DIR/wall0.png

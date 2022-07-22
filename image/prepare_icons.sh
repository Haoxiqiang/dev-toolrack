#!/bin/bash

# ./prepare_icons.sh filename.png dst_dir
base=$1

dst=$2/res/
declare -a dirs=("mipmap-mdpi/" "mipmap-hdpi/" "mipmap-xhdpi/" "mipmap-xxhdpi/" "mipmap-xxxhdpi/" "mipmap-nodpi/")
declare -a sizes=(48 72 96 144 192 512)

iconSize=${#dirs[@]}

for (( i=0; i<${iconSize}; i++ ));
do
  file="${dst}${dirs[$i]}"
  size="${sizes[$i]}"
  mkdir -p $file
  convert -depth 8 -colorspace sRGB -quality 90 -define png:compression-filter=5 ${base} -resize "${size}x${size}!" +profile "*" $file"/ic_launcher.png"
  radius=$((${sizes[$i]} / 2))
  convert -depth 8 -colorspace sRGB -quality 90 -define png:compression-filter=5 $file"/ic_launcher.png" \
    -gravity Center \
    \( -size "${size}x${size}" \
       xc:Black \
       -fill White \
       -draw "circle $radius $radius $radius 0" \
       -alpha Copy \
    \) -compose CopyOpacity -composite \
    -trim $dst${dirs[$i]}"/ic_launcher_round.png"
done

#!/bin/bash
#usage: webp2gif input.webp output.gif
#https://github.com/elsonwx/webp2gif

cur_dir=$(pwd)
temp_dir=$(mktemp -d)
echo $temp_dir 
cd $temp_dir
webpfile=$1
if [[ ! -f $webpfile ]];then
    webpfile=$cur_dir/$webpfile
fi

frames_num=$(webpinfo $webpfile|grep Format|wc -l)

for i in $(seq 0 $frames_num);do
	
	if [[ $i -eq 0 ]]
	then
	     i=$(($frames_num+1))
    fi
	
	name=$i

	if [[ $i -lt 10 ]]
	then
	     name="00$i"
	elif [[ $i -lt 100 ]]
	then
	     name="0$i"
	elif [[ $i -gt 99 ]]
	then
	     name="$i"
	else
	    echo "Over!!"
	fi

    webpmux -get frame $i $webpfile -o "$name.webp"
    dwebp "$name.webp" -o "$name.png"
done;

convert -delay 10 -loop 0 *.png animation.gif
#convert -fuzz 1% -delay 1x8 *.png -coalesce -layers OptimizeTransparency animation.gif

mv $temp_dir/animation.gif $cur_dir/$2
rm -rf $temp_dir
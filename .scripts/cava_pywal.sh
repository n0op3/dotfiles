color1=$( awk 'match($0, /color0=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh )
color2=$( awk 'match($0, /color1=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh )

sed -e "s/%%%%%%%/$color2/" -e "s/+++++++/$color1/" ~/.config/cava/config.colors > /tmp/cava_colors
cat ~/.config/cava/config >> /tmp/cava_colors
pid=$(pidof cava)

if [ -z $1 ]; then
  [ -z $pid ] && cava -p /tmp/cava_colors || kill -USR2 $pid
else
  [ -z $pid ] || kill -USR2 $pid
fi

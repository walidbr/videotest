#!/bin/sh
echo "Usage ./test001.sh <filename> "
WIDTH=1920
HEIGHT=1080
FRAMESIZE=$(( $WIDTH*$HEIGHT ))
FRAMESIZE=$(( $FRAMESIZE+$FRAMESIZE/2 ))
FRAMEOFFSET=$(( $FRAMESIZE*$2 ))
MAXYUVFRAMES_N=$(( 1+$2 ))
echo $FRAMESIZE
rm -rf *.yuv
ffmpeg -i $1 -start_number 1 -frames:v $MAXYUVFRAMES_N -c:v rawvideo -pix_fmt yuv420p tmp.yuv
dd if=tmp.yuv of=frame$2.yuv bs=1 skip=$FRAMEOFFSET count=$FRAMESIZE
ffplay -f rawvideo -pix_fmt yuv420p -s 1920x1080 -i frame$2.yuv 
rm -rf tmp.yuv
exit


#THis is for test purposes
ffmpeg -i Barcelona02.wmv -start_number 1 -vframes 300 -frames:v 30 -c:v rawvideo -pix_fmt yuv420p out.yuv
ffplay -f rawvideo -pix_fmt yuv420p -s 1920x1080 -i out.yuv 
ffmpeg -i Barcelona02.wmv -frames:v 300 -vf select='between(n\,300\,600)' -c:v rawvideo -pix_fmt yuv420p out.yuv
dd if=out.yuv of=croppedout.yuv bs=1 skip=31104000 count=3110400

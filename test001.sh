#!/bin/sh
echo "Usage ./test001.sh <filename> "
WIDTH=1920
HEIGHT=1080
FRAMESIZE=$(( $WIDTH*$HEIGHT ))
FRAMESIZE=$(( $FRAMESIZE+$FRAMESIZE/2 ))
FRAMEOFFSET=$(( $FRAMESIZE*$2 ))
MAXYUVFRAMES_N=$(( 1+$2 ))
echo $FRAMESIZE
rm -rf *.yuv *.h
########################## Method 1 DD ##############################
#ffmpeg -i $1 -start_number 1 -frames:v $MAXYUVFRAMES_N -c:v rawvideo -pix_fmt yuv420p tmp.yuv
#dd if=tmp.yuv of=frame$2.yuv bs=1 skip=$FRAMEOFFSET count=$FRAMESIZE
########################## Method 2 FFMPEG (Faster) ##############################
ffmpeg -i $1 -pix_fmt yuv420p -vframes 1 -ss $2 frame$2.yuv
#ffmpeg -i $1 -pix_fmt yuv420p -vframes 1 -ss 00:00:30.000 frame$2.yuv



xxd -i -a frame$2.yuv > frame$2.h
ffplay -f rawvideo -pix_fmt yuv420p -s 1920x1080 -i frame$2.yuv 
exit


#THis is for test purposes
ffmpeg -i Barcelona02.wmv -start_number 1 -vframes 300 -frames:v 30 -c:v rawvideo -pix_fmt yuv420p out.yuv
ffplay -f rawvideo -pix_fmt yuv420p -s 1920x1080 -i out.yuv 
ffmpeg -i Barcelona02.wmv -frames:v 300 -vf select='between(n\,300\,600)' -c:v rawvideo -pix_fmt yuv420p out.yuv
dd if=out.yuv of=croppedout.yuv bs=1 skip=31104000 count=3110400
ffmpeg -i in.mp4 -vf select='eq(n\,100)+eq(n\,184)+eq(n\,213)' -vsync 0 frames%d.jpg
# From YUV stream yo YUV files
ffmpeg -f rawvideo -framerate 25 -s 1920x1080 -pixel_format yuv420p -i in.yuv -c copy -f segment -segment_time 0.01 frames%d.yuv

ffmpeg -i video.ts -pix_fmt yuv420p -vframes 1 foo-1.yuv
ffmpeg -i Barcelona02.wmv -pix_fmt yuv420p -vframes 100 -ss 00:00:30 foo-1.yuv
ffmpeg -i Barcelona02.wmv -pix_fmt yuv420p -ss 00:00:30 -t 00:00:22 foo-1.yuv

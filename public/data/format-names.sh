#!/bin/sh

# Screenshot from 2015:11:08:04:54:09.png

cd /mnt/Storage/Pictures/Screenshots

rename 's/ from /\ /g' *.png
rename 's/-/\ /g' *.png
rename 's/\:/\ /g' *.png

rename 's/Screenshot 14/\Screenshot 2014/g' *
rename 's/Screenshot 15/\Screenshot 2015/g' *

ls -ls


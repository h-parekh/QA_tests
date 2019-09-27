#! /bin/sh

for i in /etc/selenium/spec/* ;
    do 
        python3 $i || exit 1
    done

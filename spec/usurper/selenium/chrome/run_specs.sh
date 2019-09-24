#! /bin/sh

for i in /etc/selenium/spec/* ;
    do
        python3 $i
    done

#!/bin/bash 

for i in {1..65000}
do 

2>/dev/null echo 1 > /dev/tcp/$1/$i
if [ $(echo $?) = "0" ] 
then
echo -e "port $i open"
fi

done

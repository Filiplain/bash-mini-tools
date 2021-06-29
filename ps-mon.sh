#!/bin/bash

#change seconds as you want it
seconds=4

ps1=$(ps -eo command)
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"

trap ctrl_c INT

function ctrl_c(){
echo -e "\n\n\n${red}Exiting...${end}"
echo -e "\n\n\n${blue}Out File:${end} /tmp/newproc.txt"
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"
exit 0
}


echo -e "${blue}\nStarting Process Monitor\n${end}"
for n in $(seq 1 1000)
do
        echo -e "${blue}\nRunning each${end} ${yellow}$seconds${end} ${blue}seconds:${end} $n${red}/${end}1000\n\n"
	ps2=$(ps -eo command)
        diff <(echo "$ps1") <(echo "$ps2") >> /tmp/newproc.txt 
        ps1=$ps2
	tail /tmp/newproc.txt
        sleep $seconds
	clear
        

done
echo -e "\n\n\n${blue}Out File:${end} /tmp/newproc.txt"
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"

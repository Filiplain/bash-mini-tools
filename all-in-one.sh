#!/bin/bash

#bash-Nmap all in one port scanner
# -Filiplain-

end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"

trap ctrl_c INT

function ctrl_c(){
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"
rm tcp.tmp
rm udp.tmp
exit 0

}


if [ "$1" ]
then
echo -e "${blue}\nScanning TCP ports${end} \n"
allTCPports=$(nmap -Pn --min-rate 5000 -p- $1|grep 'tcp' |cut -d '/' -f 1 > tcp.tmp;cat tcp.tmp|tr '\n' ',')
  
  if [ -s ./tcp.tmp ]
    then
    echo -e "\n${blue}Open TCP ports:${end}${yellow} \n $(echo $allTCPports| tr ',' '\n')${end}\n\n"
    echo -e "\n${blue}Full Scan for Open TCP ports:\n${end}"
    nmap -Pn -sV -sC -p$allTCPports $1 > tcp.txt
    cat tcp.txt
    
  else
      echo -e "${red}\n\n -- No TCP ports open -- \n\n${end}"  
  fi
  if [ $(id -u) == "0" ]
  then
       echo -e "\n ${blue}Scanning UDP ports ${end}\n"
       udpports=$(nmap -Pn -sU --min-rate 5000 --open $1|grep 'udp' |cut -d '/' -f 1 > udp.tmp;cat udp.tmp|tr '\n' ',')
       if [ -s ./udp.tmp ]
         then    
         echo -e "\n${blue}Open UDP ports:${end}${yellow} \n $(echo $udpports| tr ',' '\n')${end}\n\n"
         echo -e "\n${blue}Full Scan for Open UDP ports:\n${end}"
         nmap -Pn -sU -sV -sC -p$udpports $1 > udp.txt
         cat udp.txt
         
       else
          echo -e "${red}\n\n -- No UDP ports open -- \n\n${end}"
       		
       
       fi

  else
     echo -e "${red}\n For UDP scan you need root privileges.\n Usage: sudo $0 <IP address>${end}"
  
  fi


else
   echo -e "${red}\n Usage: $0 <IP address>${end}"

fi
rm tcp.tmp
rm udp.tmp
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"

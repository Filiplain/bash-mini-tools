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
if [ -f udp.tmp ];then rm udp.tmp;fi
if [ -f tcp.tmp ];then rm tcp.tmp;fi
if [ -f snmpwalkv1.tmp ];then rm snmpwalkv1.tmp;fi
if [ -f snmpwalkv2c.tmp ];then rm snmpwalkv2c.tmp;fi
if [ -f where.tmp ];then rm where.tmp;fi
exit 0
}


if [ "$1" ]
then
echo -e "${blue}\nScanning TCP ports${end} \n"
allTCPports=$(nmap -Pn -n --max-retries=0 --min-rate 5000 --open -p- $1|grep 'tcp' |cut -d '/' -f 1 > tcp.tmp;cat tcp.tmp|tr '\n' ',')
  
  if [ -s ./tcp.tmp ]
    then
    echo -e "\n${blue}Open TCP ports:${end}${yellow} \n $(echo $allTCPports| tr ',' '\n')${end}\n\n"
    echo -e "\n${blue}Full Scan for Open TCP ports:\n${end}"
    nmap -Pn -n -sV -sC -p$allTCPports $1 > tcp.txt
    cat tcp.txt
    
  else
      echo -e "${red}\n\n -- No TCP ports open -- \n\n${end}"  
  fi
  if [ $(id -u) == "0" ]
  then
       echo -e "\n ${blue}Scanning UDP ports ${end}\n"
       udpports=$(nmap -Pn -sU -n --max-retries=0 --min-rate 5000 --open $1|grep 'udp' |cut -d '/' -f 1 > udp.tmp;cat udp.tmp|tr '\n' ',')
       if [ -s ./udp.tmp ]
         then    
         echo -e "\n${blue}Open UDP ports:${end}${yellow} \n $(echo $udpports| tr ',' '\n')${end}\n\n"
         echo -e "\n${blue}Full Scan for Open UDP ports:\n${end}"
         nmap -Pn -n -sU -sV -sC -p$udpports $1 > udp.txt
         cat udp.txt
         
       else
          echo -e "${red}\n\n -- No UDP ports open -- \n\n${end}"
       		
       
       fi

  else
     echo -e "${red}\n For UDP scan you need root privileges.\n Usage: sudo $0 <IP address>${end}"
  
  fi
  whereis snmpwalk|cut -d ":" -f 2 > where.tmp
  if [ -s ./where.tmp ];then
      echo -e "\n${blue}Checking if SNMP available (Public):\n${end}"
      snmpwalk -v 1 -c public $1 iso.3.6.1.2.1.1.1.0 > snmpwalkv1.tmp
      snmpwalk -v 2c -c public $1 iso.3.6.1.2.1.1.1.0 > snmpwalkv2c.tmp
      sleep 5
      if [ -s snmpwalkv1.tmp ] || [ -s snmpwalkv2c.tmp ];then
       echo -e "${blue}\n SNMP v1:\n\n${end} $(cat ./snmpwalkv1.tmp)"
       echo -e "${blue}\n SNMP v2c:\n\n${end} $(cat ./snmpwalkv2c.tmp)"
      else
      	 echo -e "${red}\n\n -- No SNMP Availabe (Public) -- \n\n${end}"
      fi
  else
     echo -e "\n${blue}Install snmpwalk to ckeck SNMP:${end}\n${red}sudo apt install snmp${end}"
  
  fi 
  rm ./where.tmp
else
   echo -e "${red}\n Usage: $0 <IP address>${end}"

fi
if [ -f udp.tmp ];then rm udp.tmp;fi
if [ -f tcp.tmp ];then rm tcp.tmp;fi
if [ -f snmpwalkv1.tmp ];then rm snmpwalkv1.tmp;fi
if [ -f snmpwalkv2c.tmp ];then rm snmpwalkv2c.tmp;fi
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"

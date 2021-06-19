#!/bin/bash

nmap -Pn -sV -sC -p$(nmap -Pn --min-rate 5000 -p- $1|grep 'tcp' |cut -d '/' -f 1 |tr '\n' ',') $1 > tcp.txt;cat tcp.txt
nmap -Pn -sU -sV -sC -p$(nmap -Pn -sU $1|grep 'udp' |cut -d '/' -f 1 |tr '\n' ',') $1 > udp.txt;cat udp.txt


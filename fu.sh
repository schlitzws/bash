#!/bin/bash
echo "This program is used to gather your /var/log/auth.log data of a from a specified target trying to connect via ssh."
echo "Where do you want to store the file? IF the file does not exist the file will be created for you. "
read storel
touch $storel
#if [!$l]
#then
#touch $l
#else
#mv  /home/llun/Ghast/logofEst /home/llun/Ghast/PersonalLogs.txt
#$l = /home/llun/Ghast/PersonalLogs.txt
#fi
pwd=`pwd`
cd $pwd
echo "You are in $pwd"

if [ "$x" == "$targetdir" ]
then
  echo "enter the ip address of target:"
  read target
  echo "grabbing data"
  cat /var/log/auth.log | grep "$target" > $storel
fi


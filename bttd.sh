#!/bin/bash
ipTablsrc="/home/guls/Documents/KEEP/TRGT_FLD/srcIP_final"
echo "If you have not made your whitelist file please do so now before continuing ctrl-C to exit."
echo "If you have the whitelist file please enter it's destination now."
read whiteIPs
mapfile -t warry < "$whiteIPs"
echo "This program is used to ban any ips that have failed login in  /var/log/auth.log for ssh."
echo "Please enter the destination or name (if you want to save to the cd) of the first temp file"
read blockIPs
if [ ! -d $blockIPs ]
then touch $blockIPs
fi
echo "Grabbing auth.log data...through select keywords."
echo "Please enter the destination or name of the second temp file."
read ld
cat /var/log/auth.log | grep "Failed password"  |  sort -u >  $blockIPs
cat /var/log/auth.log | grep "Received disconnect" | sort -u >> $blockIPs
mapfile -t tarry < "$blockIPs"
for ip in "${tarry[@]}"; do
echo "$ip" | grep -o '[0-9,.]\+' | sort -u  >> $ld; done
echo "Done Grabbing Log Data"
#cat /var/log/auth.log | grep -o '[0-9,.]\+' | cut -d ' ' -f 25 | sort -u >> $blockIPs
cat $ld
echo "Please enter 3 temp file for filtering out the numbers found in the auth.log data to ips"
read filtdst
touch $filtdst
cat $ld > $filtdst
mapfile -t blkArr < "$filtdst"
for ip in "${blkArr[@]}"; do 
echo "$ip"; 
if [ "${#ip}" -ge "10" ];
then 
echo $ip >> "$ipTablsrc"
fi ;
done
echo "This is the final filtered list of blocked ips."
read finFilt
touch $finFilt
touch $ipTablsrc
cat $ipTablsrc | sort -u > "$finFilt"
cat $finFilt
echo "Starting IPTABLES auto block.."
mapfile -t finalfil < "$finFilt"
for ip in "${finalfil[@]}"; do echo "Blocking $ip"
iptables -I INPUT -s $ip -p tcp --dport ssh -j REJECT;
echo "$ip is Blocked";
done


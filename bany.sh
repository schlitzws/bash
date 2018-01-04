#!/bin/bash
ipTablsrc="/home/guls/Documents/KEEP/TRGT_FLD/srcIP_final"
echo "This program is used to ban any ips that have failed login in  /var/log/auth.log for ssh."
echo "Choose the destination file for blocked ips if file doesn't exist it will be created."
read blockIPs
if [ ! -d $blockIPs ]
then touch $blockIPs
fi
echo "Grabbing log data..."
cat /var/log/auth.log | grep "Failed*" | cut -d ' ' -f 14 | sort -u > $blockIPs
cat /var/log/auth.log | grep "Failed*" | cut -d ' ' -f 11 | sort -u >> $blockIPs
cat /var/log/auth.log | grep "Failed*" | cut -d ' ' -f 13 | sort -u >> $blockIPs
cat $blockIPs
echo "Filtering log data..." 
echo "Provide filtered target data destination:"
read  filtdst
cat $blockIPs | grep -o '[0-9,.]\+' > "$filtdst"
cat $filtdst
mapfile -t blkArr < "$filtdst"
for ip in "${blkArr[@]}"; do 
echo "$ip"; 
if [ "${#ip}" -ge "10" ];
then 
echo $ip >> "$ipTablsrc"
fi ;
done
echo "This is the final filtered list of blocked ips."
echo "Provide final filter location..file"
read finFilt
touch $ipTablsrc
cat $ipTablsrc | sort -u > "$finFilt"
cat $finFilt
echo "Starting IPTABLES auto block.."
mapfile -t finalfil < "$finFilt"
for ip in "${finalfil[@]}"; do echo "Blocking $ip"
iptables -I INPUT -s $ip -p tcp --dport ssh -j REJECT;
echo "$ip is Blocked";
done


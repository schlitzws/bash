echo "Insert your file location for whitelist"
read whitel
mapfile -t warry < "$whitel"
for ip in "${warry[@]}"; do
echo "Whitelisting $ip"
iptables -A INPUT -s $ip -j ACCEPT
iptables -A OUTPUT -d $ip -j ACCEPT
done


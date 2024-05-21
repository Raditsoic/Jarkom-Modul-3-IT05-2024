echo 'nameserver 192.168.122.1' > /etc/resolv.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.66.0.0/16

apt-get update
apt-get install isc-dhcp-relay -y

bash /root/arakis.sh


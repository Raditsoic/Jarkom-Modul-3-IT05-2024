host Paul {
    hardware ethernet 86:28:2c:ef:7a:81;
    fixed-address 10.66.2.203;
    option host-name "Paul";
} > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
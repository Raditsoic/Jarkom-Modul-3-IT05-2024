echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

echo 'subnet 10.66.1.0 netmask 255.255.255.0 {
    range 10.66.1.14 10.66.1.28;
    range 10.66.1.49 10.66.1.70;
    option routers 10.66.1.0;
    option broadcast-address 10.66.1.255;
    option domain-name-servers 10.66.3.1;
    default-lease-time 300;
    max-lease-time 5220;
}

subnet 10.66.2.0 netmask 255.255.255.0 {
    range 10.66.2.15 10.66.2.25;
    range 10.66.2.200 10.66.2.210;
    option routers 10.66.2.0;
    option broadcast-address 10.66.2.255;
    option domain-name-servers 10.66.3.1;
    default-lease-time 1200;
    max-lease-time 5220;
}

subnet 10.66.3.0 netmask 255.255.255.0 {
}

subnet 10.66.4.0 netmask 255.255.255.0 {
}' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
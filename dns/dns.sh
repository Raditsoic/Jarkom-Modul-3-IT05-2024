echo 'zone "atreides.it05.com" {
    type master;
    file "/etc/bind/jarkom/atreides.it05.com";
};

zone "harkonen.it05.com" {
    type master;
    file "/etc/bind/jarkom/harkonen.it05.com";
};' > /etc/bind/named.conf.local


mkdir -p /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/atreides.it05.com
cp /etc/bind/db.local /etc/bind/jarkom/harkonen.it05.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it05.com. root.atreides.it05.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it05.com.
@       IN      A       10.66.2.1     ; IP Leto
' > /etc/bind/jarkom/atreides.it05.com

echo '
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it05.com. root.harkonen.it05.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it05.com.
@       IN      A       10.66.1.1     ; IP Vladimir
' > /etc/bind/jarkom/harkonen.it05.com

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;
      listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

service bind9 start
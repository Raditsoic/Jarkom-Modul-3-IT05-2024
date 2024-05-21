apt-get update
apt-get install lynx -y
apt-get install apache2-utils -y
apt-get install jq

echo '
{
    "username": "kelompokit05",
    "password": "passwordit05"
}
' > /root/login.json
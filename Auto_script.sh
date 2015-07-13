#!/bin/bash
trap ' ' 2
onstate="0"
ipvps=`wget http://ipecho.net/plain -O - -q ; echo`
sudo apt-get install nano -y
sudo apt-get insstal curl -y
sudo apt-get install chmod -y
sudo apt-get install dpkg -y
# ================================================================================​==
# ================== Places Function you need ======================================
# 1===
funct_update()
{
sudo apt-get update -y
}
# 2===
funct_upgrade()
{
sudo apt-get upgrade -y
}
# 3===
funct_webmin()
{
sudo echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list
sudo echo 'deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' >> /etc/apt/sources.list
wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sudo apt-get update -y
sudo apt-get install webmin -y
sudo echo '/bin/false' >> /etc/shells
funct_update
}
# 4===
funct_openssh()
{
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo sed -i 's/# Port 22/Port 60000/g' /etc/ssh/sshd_config
# ===
sudo sed -i '/^Port 22/ s:$:\nPort 109:' /etc/ssh/sshd_config
sudo sed -i '/^Port 22/ s:$:\nPort 53:' /etc/ssh/sshd_config
}
# 5===
funct_apache()
{
sudo sed -i 's/NameVirtualHost *:80/NameVirtualHost *:88/g' /etc/apache2/ports.conf
sudo sed -i 's/Listen 80/Listen 88/g' /etc/apache2/ports.conf
sudo service apache2 restart
}
# 6===
funct_dropbear()
{
sudo apt-get install dropbear -y
# ===
sudo sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sudo sed -i 's/DROPBEAR_PORT=22/# DROPBEAR_PORT=22/g' /etc/default/dropbear
sudo sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 7788"/g' /etc/default/dropbear
}
# 7===
funct_squid()
{
sudo apt-get install squid3 -y
sudo echo 'acl server1 dst '$ipvps'-'$ipvps'/255.255.255.255' >> /etc/squid3/squid.conf
sudo echo 'http_access allow server1' >> /etc/squid3/squid.conf
sudo echo 'http_port 80' >> /etc/squid3/squid.conf
sudo echo 'http_port 8080' >> /etc/squid3/squid.conf
sudo echo 'http_port 8000' >> /etc/squid3/squid.conf
# ===
sudo echo 'forwarded_for off' >> /etc/squid3/squid.conf
sudo echo 'visible_hostname server1' >> /etc/squid3/squid.conf
}
# 8===
funct_openvpn()
{
echo -e "Script un-config yet \n"
}
# 9===
funct_badvpn()
{
echo -e "Script un-config yet \n"
}
# 10===
funct_pptpvpn()
{
sudo apt-get install pptpd -y
sudo echo 'localip '$ipvps >> /etc/pptpd.conf
sudo echo 'remoteip 10.10.0.1-200' >> /etc/pptpd.conf
sudo echo 'ms-dns 8.8.8.8' >> /etc/ppp/pptpd-options
sudo echo 'ms-dns 8.8.4.4' >> /etc/ppp/pptpd-options
# === add user pptp
sudo echo '#username[tabkey]*[tabkey]password[tabkey]*' >> /etc/ppp/chap-secrets
sudo echo '#myusername    *    mypassword    *' >> /etc/ppp/chap-secrets
# === 
sudo echo 'ifconfig $1 mtu 1400' >> /etc/ppp/ip-up
# ===
sudo iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o venet0 -j SNAT --to $ipvps
sudo iptables -t nat -A POSTROUTING -j SNAT --to-source $ipvps
# ===
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' >> /etc/sysctl.conf
sudo sysctl -p
# === 
echo -e '\n'
echo -e 'default user have been create as :'
echo -e 'username = myusername'
echo -e 'password = mypassword \n'
echo -e 'edit "/etc/ppp/chap-secrets" to adduser more \n'
echo -e 'Continue \c'
}
# 11===
funct_softvpn()
{
sudo apt-get update -y
sudo apt-get install build-essential -y
sudo tar zxf http://citylan.dl.sourceforge.net/project/vpsmanagement/softether-64bit.tar.gz
sudo cd vpnserver
sudo make
sudo cd ..
sudo mv vpnserver /usr/local
sudo cd /usr/local/vpnserver/
sudo chmod 600 *
sudo chmod 700 vpncmd
sudo chmod 700 vpnserver
}
# 12===
funct_fail2ban()
{
echo -e "Script un-config yet \n"
}
# 13===
funct_userlogin()
{
sudo curl -s http://jaist.dl.sourceforge.net/project/vpsmanagement/user-login.sh > user-login.sh
sudo chmod +x user-login.sh
}
# 14===
funct_speedtest()
{
sudo apt-get install python -y
wget https://github.com/sivel/speedtest-cli/raw/master/speedtest_cli.py
sudo chmod a+rx speedtest_cli.py
}
# 15===
funct_setall()
{
funct_update
funct_upgrade
funct_webmin
funct_openssh
funct_apache
funct_dropbear
funct_squid
funct_openvpn
funct_badvpn
funct_pptpvpn
funct_fail2ban
funct_userlogin
funct_speedtest
funct_react
}
# 16===
funct_react()
{
sudo service apache2 restart
sudo service squid3 restart
sudo service ssh restart
sudo service dropbear restart
sudo service webmin restart
sudo pptpd restart
sudo ./user-login.sh
sudo python speedtest_cli.py --share
sudo netstat -ntlp
}
# AUTO SCRIPT DEBIAN ==
clear
while true
do
  onstate="1"
  clear
  echo "=============================================="
  echo "         DEBIAN-UBUNTU VPS MANAGEMENT         "
  echo "=============================================="
  echo " 1. Update"
  echo " 2. Upgrade"
  echo " 3. Install Webmin"
  echo " 4. Managed Port OpenSSH"
  echo " 5. Managed Port Apache2"
  echo " 6. Install and Managed Port Dropbear"
  echo " 7. Install and Managed Squid3"
  echo " 8. Install and Managed OPEN VPN"
  echo " 9. Install and Managed BAD VPN"
  echo "10. Install and Managed PPTP VPN"
  echo "11. Install and Managed VPN Server/Softether"
  echo "12. Install and Managed Fail2Ban"
  echo "13. Add Script User-Login"
  echo "14. Add Speedtest-CLI"
  echo "=========================================="
  echo "15. Setup All in One"
  echo "16. Restart and Activated All Managed"
  echo "17. Exit"
  echo -e "\n"
  echo -e "Type number choice : \c"
  read choice
  case "$choice" in
    1) funct_update ;;
    2) funct_upgrade ;;
    3) funct_webmin ;;
    4) funct_openssh ;;
    5) funct_apache ;;
    6) funct_dropbear ;;
    7) funct_squid ;;
    8) funct_openvpn ;;
    9) funct_badvpn ;;
   10) funct_pptpvpn ;;
   11) funct_softvpn ;;
   12) funct_fail2ban ;;
   13) funct_userlogin ;;
   14) funct_speedtest ;;
   15) funct_setall ;;
   16) funct_react ;;
   17) exit ;;
  esac
  echo -e 'Enter return to Continue \c'
  read input
done

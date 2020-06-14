sudo sed -i -- s/"raspberrypi"/"rasp-int-02"/g /etc/hosts 
sudo sed -i -- s/"raspberrypi"/"rasp-int-02"/g /etc/hostname 

# set static ip
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf_SAVE
sudo touch /etc/dhcpcd.conf
echo interface eth1 | sudo tee -a /etc/dhcpcd.conf
echo static ip_address=10.2.0.2/24 | sudo tee -a /etc/dhcpcd.conf
echo static routers=10.2.0.1 | sudo tee -a /etc/dhcpcd.conf
echo static domain_name_servers=10.0.0.1 8.8.8.8 | sudo tee -a /etc/dhcpcd.conf

# Locale
sudo dpkg-reconfigure tzdata
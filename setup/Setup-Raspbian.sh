# Run these scripts after provisioning the virtual hardware and installing the OS

# Set localization options
# Set hostname
# Enable SSH
# Configure static IP
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf_SAVE
sudo touch /etc/dhcpcd.conf
echo interface eth0 | sudo tee -a /etc/dhcpcd.conf
echo static ip_address=10.2.0.2/24 | sudo tee -a /etc/dhcpcd.conf
echo static routers=10.2.0.1 | sudo tee -a /etc/dhcpcd.conf
echo static domain_name_servers=10.0.0.1 8.8.8.8 | sudo tee -a /etc/dhcpcd.conf
sudo ifconfig eth0 down
sudo ifconfig eth0 up

# Test SSH
# Test connection to web server over vswitch

# Set hostname
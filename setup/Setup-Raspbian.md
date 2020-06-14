# On HyperV Raspbian VM. 

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install hyperv-daemons

# Now we can enable Guest Integration in PowerShell and transfer files back and forth...of course this is primarily useful for configuring the net adapter and that must already be done in order to run apt so...not sure how this helps. Maybe we can create new ISO of the image after setting it up...

## USE SSH

This may be the most automation-friendly method for configuring a Raspbian VM.

First, run the Create-RaspbianVm script in powershell to provision two Raspbian VMs. HOWEVER...instead of attaching custom NAT switches use the Default Switch. We don't want to do this long term because it generates a new IP every time it boots. For now we just need to connect to the internet and the host machine so we can install updates and SSH in to the VM.

Connect to the VMs through HyperV Manager and walk through the installer to install the OS.

Once you have booted to the Raspbian desktop you only have to run one command: 
<pre>
sudo service ssh start
</pre>
This will start the SSH server, allowing you to run scripts on the VM from your Windows terminal. With this we can configure the VM's hostname, static IP, locale, passwords, and install all the packages we need to run our web server.

Connect to the pi via SSH:

<pre>
ssh pi@raspberry
</pre>

The default password is "raspberry". We'll change that first. Once you are connected via SSH, do this:

## Set passwords for default accounts.

<pre>
passwd
</pre>
Enter the password for the pi user then...

Enter a password for the root user:
<pre>
passwd
</pre>

## Set hostname
sudo sed -i -- s/"raspberrypi"/"rasp-int-02"/g /etc/hosts 
sudo sed -i -- s/"raspberry"/"rasp-int-02"/g /etc/hostname 

## Configure static IP
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf_SAVE
sudo touch /etc/dhcpcd.conf
echo interface eth1 | sudo tee -a /etc/dhcpcd.conf
echo static ip_address=10.2.0.2/24 | sudo tee -a /etc/dhcpcd.conf
echo static routers=10.2.0.1 | sudo tee -a /etc/dhcpcd.conf
echo static domain_name_servers=10.0.0.1 8.8.8.8 | sudo tee -a /etc/dhcpcd.conf

## Set localization options
echo "Setting the timezone to Pacific time..."
sudo dpkg-reconfigure tzdata

## Shutdown and add NAT switch
<pre> sudo shutdown <pre>


# Test SSH
# Test connection to web server over vswitch


# sudo cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime 
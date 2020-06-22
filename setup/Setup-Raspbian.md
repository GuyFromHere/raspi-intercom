# Setting up a Raspberry Pi with Raspbian Buster

These steps will work for a physical or virtual image. The only caveat is that setting up networking on the virtual switch can be tricky. Check out the powershell scripts for instructions on configuring a vSwitch with a static NAT.

Follow the instructions on the Raspbian website to download the image and run the Windows imager utility.

Walk through the installer to install the OS.

## Update the pi
Once you have booted to the Raspbian desktop and connected to the internet via wifi or ethernet, open a terminal window and get updates.

<pre>
sudo apt-get update -y && sudo apt-get upgrade -y
</pre>

When that's finished, enable SSH. You can disable it again later but this makes the setup process much easier.

<pre>
sudo service ssh start
</pre>

This will start the SSH server, allowing you to run scripts on the pi from your Windows terminal. .

Connect to the pi via SSH:

<pre>
ssh pi@raspberry
</pre>

The default password is "raspberry". We'll change that first. Once you are connected via SSH, do this:

## Set passwords for default accounts.

Enter the password for the pi user
<pre>
passwd
</pre>

Enter a password for the root user:
<pre>
sudo passwd
</pre>

## Set hostname
Replace ${HOSTNAME} with whatever you want to call the device.

<pre>
sudo sed -i -- s/"raspberrypi"/"${HOSTNAME}"/g /etc/hosts 
sudo sed -i -- s/"raspberry"/"${HOSTNAME}"/g /etc/hostname 
</pre>

## Configure static IP
OPTIONAL. These are the settings I used for my VMs but on the physical Pis I just leave DHCP enabled.

<pre>
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf_SAVE
sudo touch /etc/dhcpcd.conf
echo interface eth0 | sudo tee -a /etc/dhcpcd.conf
echo static ip_address=10.2.0.2/24 | sudo tee -a /etc/dhcpcd.conf
echo static routers=10.2.0.1 | sudo tee -a /etc/dhcpcd.conf
echo static domain_name_servers=10.0.0.1 8.8.8.8 | sudo tee -a /etc/dhcpcd.conf
</pre>


## Set localization options

<pre>sudo dpkg-reconfigure tzdata</pre>



<pre> sudo shutdown <pre>


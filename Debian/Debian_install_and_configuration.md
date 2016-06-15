# My Debian install and configuration

## Preparing the USB stick
1.  Download ISO file debian-*-amd64-netinst.iso
2.  Copy the file to the USB stick with unetbootin
3.  Boot on the USB stick

## Debian installation
1. Choose standard installation
2. Softawre selection, uncheck all except SSH server and Standard system utilities

## Debian configuration
1. Update / Upgrade
```bash
su root
apt-get update
apt-get upgrade
```
2. Add "sudo" command
```bash
su root
apt-get install sudo
adduser lamda_user sudo
```
3. Change SSH default port
```bash
sudo nano /etc/ssh/sshd_config
```
_Port XXXX_
```bash
sudo /etc/init.d/ssh restart
```

4. Reduce wait time Grub
```bash
sudo nano /etc/default/grub
```
_GRUB_TIMEOUT = 0_
```bash
sudo update-grub
```
5. Install pm-utils
```bash
sudo apt-get install pm-utils
```
6. Static IP
```bash
sudo nano /etc/network/interfaces
```
_iface eth0 inet static  
address 192.168.XX.XX  
netmask 255.255.255.0  
gateway 192.168.1.1_
```bash
sudo nano /etc/resolv.conf
```
_nameserver 192.168.1.11_
```bash
sudo /etc/init.d/networking restart
```
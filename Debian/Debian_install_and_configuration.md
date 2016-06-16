# My Debian install and configuration

## Preparing the USB stick
*  Download ISO file debian-*-amd64-netinst.iso
*  Copy the file to the USB stick with unetbootin
*  Boot on the USB stick

## Debian installation
* Choose standard installation
* Softawre selection, uncheck all except SSH server and Standard system utilities

## Debian configuration
### Update / Upgrade
```bash
su root
apt-get update
apt-get upgrade
```
### Add "sudo" command
```bash
su root
apt-get install sudo
adduser lamda_user sudo
```
### Change SSH default port
```bash
sudo nano /etc/ssh/sshd_config
```
_Port XXXX_
```bash
sudo /etc/init.d/ssh restart
```

### Reduce wait time Grub
```bash
sudo nano /etc/default/grub
```
_GRUB_TIMEOUT = 0_
```bash
sudo update-grub
```
### Install pm-utils
```bash
sudo apt-get install pm-utils
```
### Static IP
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

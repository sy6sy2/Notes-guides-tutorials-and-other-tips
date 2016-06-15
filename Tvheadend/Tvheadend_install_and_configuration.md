# My Tvheadend build, install and configuration

## Environment
- OS : Debian 8.5.0
- TV tuner : SiliconDust HDHomeRun CONNECT (2 tuners DVB-T2) (HDHR4-2DT)
- Transcoding feature

## Preliminary packages
```bash
sudo apt-get update
sudo apt-get install build-essential git pkg-config libssl-dev bzip2 wget cmake
sudo apt-get install libavahi-client-dev zlib1g-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavresample-dev libavfilter-dev  libav-tools liburiparser1 liburiparser-dev debhelper libcurl4-gnutls-dev liba52-0.7.4-dev
```

## Build and install
```bash
cd /usr/src
git clone https://github.com/tvheadend/tvheadend.git
cd tvheadend
sudo ./configure
```
>_if necessary_
```bash
sudo ./configure --enable-ffmpeg_static --enable-hdhomerun_client --enable-hdhomerun_static
```

```bash
sudo make -j8
sudo make install
```

## Create hts user in video group
We create a specific user to run tvheadend in the video group. The video group is important to allow Tvheadend to control the TV tuner.
```bash
sudo groupadd video
sudo adduser hts
sudo usermod -a -G video hts
```
>_Optionnal_
```bash
sudo adduser hts sudo
```


## Create daemon
The daemon allows us to use the _sudo tvheadend start_ and _sudo tvheadend stop_ command. Furthermore we can run Tvheadend on Debian start-up.
```bash
sudo nano /etc/init.d/tvheadend
```
>_Copy the entire tvheadend_daemon file from repo in the file /etc/init.d/tvheadend_
```bash
sudo chmod 755 /etc/init.d/tvheadend
```

>_Only if you want to run Tvheadend on Debian start-up_
```bash
sudo update-rc.d tvheadend defaults
```


## First run
The first run is particular because you have to run Tvheadend without user access control. After the Tvheadend wizard allow you to create an admin user.
```bash
su hts
/etc/init.d/tvheadend -C
```
Now open a browser at _tvheadend_ip_:9981 and follow the Tvheadend wizard.
Once the wizard completed come back to the Tvheadend bash.
> _To kill the Tvheadend process_
```bash
Ctrl+C
```

>_To start Tvheadend_
```bash
sudo service tvheadend start
```


## Divers
### Tvheadend log
```bash
sudo tail -f /var/log/syslog | grep tvheadend
```

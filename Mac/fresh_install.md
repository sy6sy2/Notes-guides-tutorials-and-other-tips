# Things to do after a clean/fresh install of Mac OS X
Last update for Mac OS X El Capitan 10.11.5

## Install iTerm 
[iTerm2 Website](https://iterm2.com)

## Install Homebrew 
[Homebrew website](https://brew.sh)
<pre>
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
</pre>

## Modify the default .bash_profile
[.bash_profile](https://github.com/SylvainCecchetto/Notes-guides-tutorials-and-other-tips/blob/master/Mac/.bash_profile)

## Install Python
<pre>
brew install python
brew install python3
</pre>

## Enable NTFS write support
[Source macplanete](http://www.macplanete.com/tutoriels/18685/ntfs-el-capitan-activer)
* Download the latest osxfuse realease : [osxfuse](https://github.com/osxfuse/osxfuse/releases)
* Install it with _Core components_ and _Preference pane_ only
* Install ntfs-3g drivers
<pre>
brew install wget
brew install homebrew/fuse/ntfs-3g
</pre>
* Disable protectionSIP  
Boot in recovery mode (cmd + R) on start-up, launch Terminal and
<pre>
csrutil disable; reboot
</pre>
* Enable automatic mounting of NTFS drives
<pre>
sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs
</pre>

## Disbale Mac chime — boot sound
[Source teored90 nobootsound](https://github.com/teored90/nobootsound)
* Download this script : https://github.com/teored90/nobootsound
* Install it with:
<pre>
sudo sh install.sh
</pre>

## Add "Open terminal here" in Finder toolbar
[Source ZipZapMac Go2Shell](http://zipzapmac.com/Go2Shell)
* Download and install Go2Shell : http://zipzapmac.com/Go2Shell

## Other app to install
* [BeardedSpice] (http://beardedspice.github.io) — Enable media keys found on Mac keyboards for web based media player
* [Amphetamine] (https://www.producthunt.com/tech/amphetamine) — Keep Mac awake
* [f.lux] (https://justgetflux.com) — Blue light reducer for Macbook
* [iStat Menus] (https://bjango.com/mac/istatmenus/) — Menubar system monitor [(profile settings)](https://github.com/SylvainCecchetto/Notes-guides-tutorials-and-other-tips/blob/master/Mac/iStat_Menus_Settings.ismp)
* [BetterTouchTool] (https://www.boastr.net) — Configure many gestures for your Magic Mouse, Macbook Trackpad and Magic Trackpad
* [Sublime Text] (http://www.sublimetext.com) — Text editor for code
* [Postman] (https://www.getpostman.com) — Test API, web requests

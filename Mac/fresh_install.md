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

## Install pip
[pip Website](https://pip.pypa.io/en/stable/installing/)
<pre>
python get-pip.py
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


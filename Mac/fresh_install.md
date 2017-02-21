# Things to do after a clean/fresh install of Mac OS X
Last update for Mac OS X El Capitan 10.11.5

## Install Homebrew 
[Homebrew website](https://brew.sh)
<pre>
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
</pre>

## iTerm2 + Oh My Zsh + Powerlevel9k 
* Install iTerm2 with Homebrew
<pre>
brew cask install iterm2
</pre>
* Install Oh My Zsh
<pre>
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
</pre>
* Install Powerlevel9k theme
<pre>
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
</pre>
Then edit your `~/.zshrc` and set `ZSH_THEME="powerlevel9k/powerlevel9k"`
* Install Material Dark color scheme
Download the color scheme [Material Dark](https://github.com/stoeffel/material-iterm/raw/master/material-dark.itermcolors) and install it.
Choose it in iTerm2 -> Preferences -> Profiles -> Default -> Colors

* Install Powerline fonts
<pre>
cd /tmp
git clone https://github.com/powerline/fonts
./fonts/install.sh
</pre>
Choose your favorite Powerline font in iTerm2 -> Preferences -> Profiles -> Default -> Text

* Enable plugins
Then edit your `~/.zshrc` and set `plugins=(sublime git z history osx brew pip)`

* Install Zsh Syntax Hightlighting
<pre>
brew install zsh-syntax-highlighting
</pre>
Follow brew instructions

* Set the correct PATH for brew
Edit your `~/.zshrc` and set
<pre>
PATH="$HOME"/bin:/opt/local/bin:/usr/local/bin:usr/local/sbin:"$PATH"
export PATH
</pre>

## Improve QuickLook macOS feature
<pre>
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json quicklook-csv betterzipql qlimagesize qlvideo
</pre>

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
    * [Package Control] (https://packagecontrol.io) — The Sublime Text package manager
    * [Anaconda] (http://damnwidget.github.io/anaconda/) — Python IDE for Sublime Text
    * [Markdown Editing] (https://github.com/SublimeText-Markdown/MarkdownEditing) — Markdown color scheme for Sublime Text
* [Postman] (https://www.getpostman.com) — Test API, web requests
* [VLC] (https://www.videolan.org/vlc/) — VLC media player, lecteur vidéo Open Source
* [Franz] (http://meetfranz.com) — All in one messaging client
* [AppCleaner] (https://freemacsoft.net/appcleaner/) — Uninstall unwanted apps
* [Paws For Trello] (http://friendlyfox.es/pawsfortrello/) — Trello desktop client
* Microsoft Office

## Macbook "System Preferences"
### Général
* Cocher "Utiliser une barrre des menus et un Dock foncés"
* Cocher "Confirmer les modifictions à la fermeture des documents"
* Décocher "Fermer les fenêtres à la fermeture d'une application"

### Dock
* Préférer les onglets pour l'ouverture des documents : Manuellement
* Cocher "Cliquez deux fois sur la berre de titre d'une fenêtre pour placer dans le dock"
* Décocher "Réduire les fenêtres dans l'icône de l'application"
* Cocher "Animer les applications lors de leur ouverture"
* Décocher "Masquer/afficher automatiquement le Dock"
* Cocher "Afficher les indicateurs des applications ouvertes"

### Mission Control
* Décocher "Réarranger automatiquement les Spaces en fonction de votre utilisation la plus récente"
* Cocher "Lors du changement d'application, activer un Space avec les fenêtres de l'application"
* Décocher "Grouper les fenêtre par application"
* Cocher "Les écrans disposent de Spaces distincts"
* Dashboard : Désactiver
* Coins actifs :
    * Haut gauche : —
    * Bas gauche : —
    * Haut droite : —
    * Bas droite : —
    
### Sécurité et confidentialité :
* Général :
    * Cocher "Exiger le mot de passe 5 secondes après la suspension d'activité
    * Cocher "Afficher un message lorsque l'écran est verrouillé"
    * Autoriser les applications téléchargées de App Store et développeurs identifiés
* FileVault : Activer
* Coupe-feu : Activer

### Trackpad
* Pointer et cliquer :
    * Recherche et détection de données : Clic forcé à un doigt
    * Clic secondaire : Cliquer ou toucher avec 2 doigts
    * Cocher "Toucher pour cliquer"
    * Clic : Léger
    * Cocher "Clic silencieux"
    * Cocher "Clic forcé et retour tactile"
* Faire défiler et zoomer
    * Cocher "Sens du défilement : naturel"
    * Cocher "Zoom avant ou arrière"
    * Cocher "Zoom intelligent"
    * Cocher "Pivoter"
* Gestes supplémentaires
    * Balayer entre les pages : Balayer avec 3 doigts
    * Balayer entre apps en plein écran : Balayer latéralement avec 4 doigts
    * Centre de notifications : Balayer de la droite vers la gauche avc 2 doigts
    * Mission Control : Balayer vers le haut avec 4 doigts
    * App Exposé : Balayer vers le bas avec 4 doigts
    * Launchpad : Pincer avec le pouce et 3 doigts
    * Afficher le bureau : Écarter le pouce et 3 doigts

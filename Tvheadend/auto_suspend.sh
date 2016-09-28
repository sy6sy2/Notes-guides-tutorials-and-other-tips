#!/bin/bash

# Source: https://github.com/git-developer/autosuspend


# Turn on auto suspend
AUTO_SUSPEND='yes'

# Suspend method: one of 'suspend', 'hibernate', 'hybrid-sleep', 'poweroff'
SUSPEND_METHOD='hibernate'

# Turning suspend by day (8 a.m. to 3 a.m.) off
#DONT_SUSPEND_BY_DAY='no'

# Automatically reboot once a week when the system isn't in use
REBOOT_ONCE_PER_WEEK='yes'

# Daemons that always have one process running, only if more that one process is active we prevent the suspend
# The values are used with grep, so just a unique portion is sufficient
#DAEMONS=''

# Important applications that shall prevent the suspend
# The values are used with grep, so just a unique portion is sufficient
#APPLICATIONS='^nxagent$ ^rsnapshot$ ^wsus$ ^wget$ ^screen$ ^mlnetp$ ^apt-get$ ^aptitude$ ^dpkg$ ^cp$'

# Network IP range for checking any open samba connections
# The value is used with grep, so just a unique portion is sufficient
#SAMBANETWORK='192.168.1.'

# Names or IP for computers that shall prevent the suspend
# We ping these computers in the list to check whether they are active.
#CLIENTS=''

#
# User for access to the Tvheadend REST API
#TVHEADEND_USER=

#
# Password for access to the Tvheadend REST API
#TVHEADEND_PASSWORD=

#
# IP for access to the Tvheadend REST API. Default: Autodetected from hostname
TVHEADEND_IP=127.0.0.1

#
# TVheadend HTTP port. Default: 9981
TVHEADEND_HTTP_PORT=9981

#
# TVheadend HTSP port. Default: 9982
TVHEADEND_HTSP_PORT=9982

#
# Boot duration of the machine. Used to wake the machine timely before the next
# recording. Default: 180 seconds
#TVHEADEND_BOOT_DELAY_SECONDS=180

#
# Autosuspension will be aborted if a recording is upcoming within the given
# duration (unit: minutes). Default: 15 minutes
#TVHEADEND_IDLE_MINUTES_BEFORE_RECORDING=15





if [ -z "$(type -t logit)" ] ; then
	logit(){
		echo AutoSuspend: $*
		return 0
	}
fi

if [ -z "$TVHEADEND_USER" ] || [ -z "$TVHEADEND_PASSWORD" ] ; then
	logit "Missing Tvheadend credentials (user and/or password)"
	return 1
fi
TVHEADEND_IP=$(echo ${TVHEADEND_IP:-$(hostname -I)} | tr -d [:space:])

IsTvheadendBusy(){
	tvheadend_status=$(curl -s --user $TVHEADEND_USER:$TVHEADEND_PASSWORD http://$TVHEADEND_IP:${TVHEADEND_HTTP_PORT:-9981}/status.xml)

	# Does also work for more than 1 'recording' element
	# recording_status=$(echo $tvheadend_status | xmlstarlet sel -t -v "currentload/recordings/recording/status='Recording'")
	# if [ "$recording_status" = "true" ] ; then
	# 	logit "Tvheadend is recording, auto suspend terminated"
	# 	return 1
	# fi

	subscriptions=$(echo $tvheadend_status | xmlstarlet sel -t -v "currentload/subscriptions")
	if [ "$subscriptions" -gt "0" ] ; then
		logit "Tvheadend has $subscriptions subscriptions, auto suspend terminated"
		return 1
	fi

	# minutes=$(echo $tvheadend_status | xmlstarlet sel -t -v "currentload/recordings/recording/next")
	# if [[ "$minutes" && "$minutes" -le ${TVHEADEND_IDLE_MINUTES_BEFORE_RECORDING:-15} ]] ; then
	# 	logit "Next Tvheadend recording starts in $minutes minutes, auto suspend terminated"
	# 	return 1
	# fi

	TVHEADEND_PORTS="${TVHEADEND_HTTP_PORT:-9981} ${TVHEADEND_HTSP_PORT:-9982}"
	LANG=C
	active_clients=()
	for port in $TVHEADEND_PORTS; do
		active_clients+=($(netstat -n | grep -oP "$TVHEADEND_IP:$port\s+\K([^\s]+)(?=:\d+\s+ESTABLISHED)"))
	done

	if [ $active_clients ]; then
	  	logit "Tvheadend has active clients: $active_clients"
	  	return 1
	fi

	return 0
}

SetWakeupTime(){
	tvheadend_dvr_upcoming=$(curl -s --user $TVHEADEND_USER:$TVHEADEND_PASSWORD http://$TVHEADEND_IP:${TVHEADEND_HTTP_PORT:-9981}/api/dvr/entry/grid_upcoming)
	now=$(date +%s)
	start_times=($(echo $tvheadend_dvr_upcoming | jq -r ".entries[] | (.start_real) | select(. > $now)" | sort -n))
	if [ ${#start_times[@]} -gt 0 ]; then
		next=${start_times[0]}
		logit "${#start_times[@]} upcoming recordings, next starts at " $(date --date @$next)
		wake_date=$(($next - ${TVHEADEND_BOOT_DELAY_SECONDS:-180}))
		echo 0 > /sys/class/rtc/rtc0/wakealarm
		logit $(/usr/sbin/rtcwake -m no -t $wake_date)
	else
	  	logit "No upcoming recordings"
	fi
}





logit(){
	logger -p local0.notice -i -t autosuspend -- $*
	return 0
}

IsOnline(){
	for i in $*; do
		ping $i -c1
		if [ "$?" == "0" ]; then
			logit "PC $i is still active, auto suspend terminated"
			return 1
		fi
	done
	return 0
}

IsRunning(){
	for i in $*; do
		if [ `pgrep -c $i` -gt 0 ] ; then
			logit "$i still active, auto suspend terminated"
			return 1
		fi
	done
	return 0
}

IsDaemonActive(){
	for i in $*; do
		if [ `pgrep -c $i` -gt 1 ] ; then
			logit "$i still active, auto suspend terminated"
			return 1
		fi
	done
	return 0
}

IsBusy(){

	# Tvheadend
	IsTvheadendBusy
	if [ "$?" == "1" ]; then
		return 1
	fi

	# Samba
	# if [ "x$SAMBANETWORK" != "x" ]; then
	# 	if [ `/usr/bin/smbstatus -b | grep $SAMBANETWORK | wc -l ` != "0" ]; then
	# 	  	logit "samba connected, auto suspend terminated"
	# 	  	return 1
	# 	fi
	# fi

	#daemons that always have one process running
	# IsDaemonActive $DAEMONS
	# if [ "$?" == "1" ]; then
	# 	return 1
	# fi

	#backuppc, wget, wsus, ....
	# IsRunning $APPLICATIONS
	# if [ "$?" == "1" ]; then
	# 	return 1
	# fi

	# Read logged users
	USERCOUNT=`who | wc -l`;
	# No Suspend if there are any users logged in
	test $USERCOUNT -gt 0 && { logit "some users still connected, auto suspend terminated"; return 1; }

	# IsOnline $CLIENTS
	# if [ "$?" == "1" ]; then
	# 	return 1
	# fi

	return 0
}

COUNTFILE="/var/spool/suspend_counter"
OFFFILE="/var/spool/suspend_off"

# turns off the auto suspend
if [ -e $OFFFILE ]; then
	logit "auto suspend is turned off by existents of $OFFFILE"
	exit 0
fi

if [ "$AUTO_SUSPEND" = "true" ] || [ "$AUTO_SUSPEND" = "yes" ] ; then
	IsBusy
	if [ "$?" == "0" ]; then
		# was it not busy already last time? Then suspend.
		if [ -e $COUNTFILE ]; then
			# only auto-suspend at night
			# if [ \( "$DONT_SUSPEND_BY_DAY" != "true" -a "$DONT_SUSPEND_BY_DAY" != "yes" \) -o \( "`date +%H`" -ge "3" -a "`date +%H`" -lt "8" \) ]; then
			# 	# notice resume-plan
			# 	NEXTWAKE="0"
			# 	if [ -e /etc/autosuspend_resumeplan ]; then
			# 		while read line; do
			# 			if [ "`date +%s -d \"$line\"`" -gt "`date +%s`" -a  \( "`date +%s -d \"$line\"`" -lt "$NEXTWAKE" -o "$NEXTWAKE" = "0" \) ]; then
			# 				NEXTWAKE="`date +%s -d \"$line\"`"
			# 			fi
			# 		done < /etc/autosuspend_resumeplan
			# 	fi
			# 	if [ "$NEXTWAKE" -gt "`date +%s`" ]; then
			# 		if [ "$NEXTWAKE" -gt "`expr \"\`date +%s\`\" + 1800`" ]; then
			# 			echo "0" > /sys/class/rtc/rtc0/wakealarm
			# 			echo "$NEXTWAKE" > /sys/class/rtc/rtc0/wakealarm
			# 			logit "will resume at $NEXTWAKE"
			# 		else
			# 			logit "do not suspend because would have been awaken within next 30 minutes"
			# 			exit 0
			# 		fi
			# 	fi
				# and suspend or reboot:
				rm -f $COUNTFILE
				if [ \( "$REBOOT_ONCE_PER_WEEK" = "true" -o "$REBOOT_ONCE_PER_WEEK" = "yes" \) -a "`echo \"scale=2; ( \`cat /proc/uptime | cut -d' ' -f1-1\` / 3600 / 24 ) >= 7\" | bc`" -gt 0 ]; then
					logit "REBOOTING THE MACHINE BECAUSE IT HAS BEEN RUNNING FOR MORE THAN A WEEK"
					shutdown -r now
				else
					logit "AUTO SUSPEND CAUSED"
					suspend_method=${SUSPEND_METHOD:-hibernate}
					logit "Suspend method: $SUSPEND_METHOD"
					SetWakeupTime
					case "$SUSPEND_METHOD" in
						"suspend")      systemctl suspend
						;;
						"hibernate")    systemctl hibernate
						;;
						"hybrid-sleep") systemctl hybrid-sleep
						;;
						"poweroff")     systemctl poweroff
						;;
						*) logit "Aborting because of unsupported suspend method: $SUSPEND_METHOD"
						;;
					esac
				fi
			# else
			# 	logit "did not auto suspend because it is broad day"
			# fi
			exit 0
		else
			# shut down next time
			touch $COUNTFILE
			logit "marked for suspend in next try"
			exit 0
		fi
	else
		rm -f $COUNTFILE
		logit "aborted"
		exit 0
	fi
fi

logit "malfunction"
exit 1

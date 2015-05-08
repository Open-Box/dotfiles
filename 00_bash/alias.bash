#!/usr/bin/env bash
########################

# Pipe my public key to my clipboard.
#alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

### Alias per forzare sovrascrittura pacchetti
#alias apt-get="sudo apt-get -o Dpkg::Options::=\"--force-overwrite\""

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


### some more ls aliases
########################
alias ll='ls -alF'
#alias ll='ls -AlF' ## con si omette la parent e la current directory
alias la='ls -A'
alias l='ls -CF' # Make ls display in columns and with a file type indicator (end directories with "/", etc) by default

### moving on directories
################################

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ....="cd ../../../.."
alias .....="cd ../../../../.."

### System Aliases
##################

# List our disk usage in human-readable units including filesystem type, and print a total at the bottom:
alias df="df -Tha --total"

#preferred du output as well:
#alias du="du -ach | sort -h"
alias du="du -ach"

# Make free output more human friendly:
alias free="free -mt"

#default output listing process table.
alias ps="ps auxf"

# Make process table searchable. Ie: `psg bash`
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"


## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'



### Networking
##############

# Have you ever needed your public IP address from the command line when you're behind a router using NAT? Something like this could be useful:
alias myip="curl http://ipecho.net/plain; echo"

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 10'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

#quickly list all TCP/UDP port on the server:
alias ports='netstat -tulanp'

# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

### Continue getting a partially-downloaded file. This is useful when you want
### to finish up a download started by a previous instance of Wget, or
### by another program
alias wget='wget -c'

# Wake-on-LAN (WOL) is an Ethernet networking standard that allows
# a server to be turned on by a network message. You can quickly wakeup
# nas devices and server using the following aliases:
## replace mac with your actual server mac address #
#alias wakeupnas01='/usr/bin/wakeonlan 00:11:32:11:15:FC'
#alias wakeupnas02='/usr/bin/wakeonlan 00:11:32:11:15:FD'
#alias wakeupnas03='/usr/bin/wakeonlan 00:11:32:11:15:FE'

### Networking - Firewall
########################
# Control firewall (iptables) output
## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# display all rules #
#alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
#alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
#alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
#alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
#alias firewall=iptlist

### WebServers Control
######################
# also pass it via sudo so whoever is admin can reload it without calling you #
#alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
#alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
#alias lightyload='sudo /etc/init.d/lighttpd reload'
#alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
#alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
#alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'


#### Miscellaneous
##################

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'





#sudo apt-get install imagemagick
# For my own purposes, I like to optimize the images I upload for articles to be 690px or less, so I use the ImageMagick package (sudo apt-get install imagemagick if not already available) which contains a command called mogrify that does just this. I have this command in my ~/.bashrc file:
alias webify="mogrify -resize 690\> *.png"
#This will resize all of the PNG images in the current directory, only if they are wider than 690px.

# install  colordiff package :)
alias diff='colordiff'

# most used command in histroy
#alias usedcmds="history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10"



# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

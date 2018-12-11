#!/bin/bash

# ==============================================================================
#  Centos 7 Server MOTD System Information
# ==============================================================================
#  Provide substantial information about the currently running system, upon
#  connection of a user.
#
#  Version: ... 0.0.1
#  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>
#  Created: ... Sun 25th, Nov. 2018 by Antoine Van Serveyt
#  License: ... MIT License
#  Updated: ...
# ==============================================================================

# Prompt colors constants
# readonly NORM="\033[0m"
# readonly BOLD="\033[1m"
# readonly GREY="\033[38;5;242m"
# readonly ACCT="\033[38;5;{{accentcolor}}m"
# readonly WHIT="\033[38;5;255m"
#
# # Message boxes size
# readonly BOXSIZE=80
readonly LABELSIZE=16

# ==============================================================================
#  Functions are defined here to speed up the writing of the rest of the script
# ==============================================================================

# Repeat a single character
repeat() {
  for (( i = 1; i <= $2; i++)); do
    echo -n "$1"
  done
}

# Prints a single line in a box
pline() {
  cstr=`echo "$2" | sed -E 's/\\\033\[([[:digit:]]{1,3};?){1,3}m//g'`
  echo -e "${GREY}║${NORM} $2`repeat " " $1-4-${#cstr}` ${GREY}║${NORM}"
}

# Prints the title line of a box
ptitle() {
  cstr=`echo "$2" | sed -E 's/\\\033\[([[:digit:]]{1,3};?){1,3}m//g'`
  echo -e "${GREY}  ╔═`repeat '═' ${#cstr}`═╗${NORM}"
  echo -e "${GREY}╔═╣${NORM} ${2} ${GREY}╠`repeat '═' $1-8-${#cstr}`═╗${NORM}"
  echo -e "${GREY}║ ╚═`repeat '═' ${#cstr}`═╝`repeat " " $1-8-${#cstr}` ║${NORM}"
  pline $1
}

# Prints the closing line of a box
pclose() {
  echo -e "${GREY}╚`repeat '═' $1-2`╝${NORM}"
}

# Prints a single line in a double box
pdline() {
  len=$(($1 / 2 - 1))
  echo "`pline $len "$2"`  `pline $len "$3"`"
}

# Prints the title line of a box
pdtitle() {
  cstr1=`echo "$2" | sed -E 's/\\\033\[([[:digit:]]{1,3};?){1,3}m//g'`
  cstr2=`echo "$3" | sed -E 's/\\\033\[([[:digit:]]{1,3};?){1,3}m//g'`
  len=$(($1 / 2 - 1))
  echo -e "${GREY}  ╔═`repeat '═' ${#cstr1}`═╗`repeat " " $len-4-${#cstr1}`  ╔═`repeat '═' ${#cstr2}`═╗${NORM}"
  echo -e "${GREY}╔═╣${NORM} ${2} ${GREY}╠`repeat '═' $len-8-${#cstr1}`═╗  ╔═╣${NORM} ${3} ${GREY}╠`repeat '═' $len-8-${#cstr2}`═╗${NORM}"
  echo -e "${GREY}║ ╚═`repeat '═' ${#cstr1}`═╝`repeat " " $len-8-${#cstr1}` ║  ║ ╚═`repeat '═' ${#cstr2}`═╝`repeat " " $len-8-${#cstr2}` ║${NORM}"
  pdline $1
}

# Prints the closing line of a box
pdclose() {
  len=$(($1 / 2 - 1))
  echo -e "${GREY}╚`repeat '═' $len-2`╝  ╚`repeat '═' $len-2`╝${NORM}"
}

# Labelize a string
label() {
  echo -n "${ACCT}${2}${GREY} `repeat '.' $1-${#2}`${NORM} "
}

# ==============================================================================
#  The actual script starts here
# ==============================================================================

# Find the current system version
version=`cat /etc/centos-release`

# Is there any pending updates?
updates=`yum check-update --quiet | grep -v "^$" | wc -l`
updates_sec=`yum check-update --quiet --security | grep -v "^$" | wc -l`
updates_notif="There is ${updates} updates available for your system,"
updates_sec_notif="among which ${updates_sec} are security-related"

if [[ $updates -gt 0 ]]; then
  updates_notif="${BOLD}${updates_notif}${NORM}"
fi

if [[ $updates_sec -gt 0 ]]; then
  updates_notif="${BOLD}${updates_sec_notif}${NORM}"
fi

# Find the system uptime
uptime_base=`cut -d. -f1 /proc/uptime`
uptime_years=`echo $((uptime_base / 60 / 60 / 24 / 365))`
uptime_months=`echo $((uptime_base / 60 / 60 / 24 / 365 % 12))`
uptime_days=`echo $((uptime_base / 60 / 60 / 24))`
uptime_hours=`echo $((uptime_base / 60 / 60 % 24))`
uptime_min=`echo $((uptime_base / 60 % 60))`
uptime_sec=`echo $((uptime_base % 60))`
uptime=`echo "${uptime_years} years ${uptime_months} months ${uptime_days} days ${uptime_hours} hours ${uptime_min} minutes ${uptime_sec} seconds"`

# Find the number of SSH sessions
session_count=`w -s | awk 'NR==1{print $4; exit}'`
session_verb="are"
session_noun="sessions"

# if ! [[ $var =~ ^-?[0-9]+$ ]]; then
#   session_count=`w -s | awk 'NR==1{print $3; exit}'`
# fi

if [ $session_count -eq 1 ]; then
  session_verb="is"
  session_noun="session"
fi

session="${session_count} SSH ${session_noun} ${session_verb} currently active"

# Find the last login date
login_wday=`lastlog -u $(whoami) | awk 'NR==2{print $3; exit}'`
login_month=`lastlog -u $(whoami) | awk 'NR==2{print $4; exit}'`
login_date=`lastlog -u $(whoami) | awk 'NR==2{print $5; exit}'`
login_time=`lastlog -u $(whoami) | awk 'NR==2{print $6; exit}'`
login_year=`lastlog -u $(whoami) | awk 'NR==2{print $8; exit}'`
login="You last logged in on ${login_wday}, ${login_date} ${login_month} ${login_year} ${login_time}"

# Find the current disk usage
usage_disk=`df -h ~/ | awk 'NR==2{print $1; exit}'`
usage_size=`df -h ~/ | awk 'NR==2{print $2; exit}'`
usage_used=`df -h ~/ | awk 'NR==2{print $3; exit}'`
usage_avai=`df -h ~/ | awk 'NR==2{print $4; exit}'`
usage_perc=`df -h ~/ | awk 'NR==2{print $5; exit}'`
usage=`echo "${usage_perc} used on ${usage_disk} (${usage_used} used / ${usage_size} total, ${usage_avai} available)"`

# Find the current CPU usage
load_1=`cat /proc/loadavg | awk '{print $1}'`
load_5=`cat /proc/loadavg | awk '{print $2}'`
load_10=`cat /proc/loadavg | awk '{print $3}'`
cpu_model=`lscpu | grep "Model name" | sed -e 's/Model name://' | awk '{print $1 " " $2}'`
cpu_cores=`lscpu | grep "CPU(s):" | sed -e 's/CPU(s)://' | awk '{$1=$1;print}'`
cpu_threads=`lscpu | grep "Thread(s) per core:" | sed -e 's/Thread(s) per core://' | awk '{$1=$1;print}'`
cpu_threads=`awk '{print $1*$2}' <<< "$cpu_cores $cpu_threads"`
cpu_freq=`lscpu | grep "CPU MHz" | sed -e 's/CPU MHz://' | awk '{$1=$1;print}'`

# Find the current memory usage
mem_avail=`free --si -m | awk 'NR==2{print $7}'`
mem_cache=`free --si -m | awk 'NR==2{print $6}'`
mem_used=`free --si -m | awk 'NR==2{print $4}'`
mem_total=`free --si -m | awk 'NR==2{print $2}'`
swap_total=`free --si -m | awk 'NR==3{print $2}'`
swap_used=`free --si -m | awk 'NR==3{print $3}'`

# Print the message box to the console
ptitle $BOXSIZE "${ACCT}System Information"
pline  $BOXSIZE "`label ${LABELSIZE} 'System Version'`${version}"
pline  $BOXSIZE "`label ${LABELSIZE} 'System Uptime'`${uptime}"
pline  $BOXSIZE "`label ${LABELSIZE} 'SSH Sessions'`${session}"
pline  $BOXSIZE "`label ${LABELSIZE} 'Last Login'`${login}"
pline  $BOXSIZE "`label ${LABELSIZE} 'Disk Usage'`${usage}"
pline  $BOXSIZE "`label ${LABELSIZE} 'Updates'`${updates_notif}"
pline  $BOXSIZE "`repeat " " $((16 + 1 + 1))`${updates_sec_notif}"
pclose $BOXSIZE

pdtitle $BOXSIZE "${ACCT}CPU Usage" "${ACCT}Memory Usage"
pdline  $BOXSIZE "`label ${LABELSIZE} 'CPU Load'``awk '{print $1*$2}' <<< "$load_1 100"`% (last minute)"  "`label ${LABELSIZE} 'Avail. Memory'`${mem_avail} / ${mem_total} MB"
pdline  $BOXSIZE "`label ${LABELSIZE} 'CPU Model'`${cpu_model}"                                           "`label ${LABELSIZE} 'Memory Load'`$((${mem_used} / ${mem_total} * 100))% (used)"
pdline  $BOXSIZE "`label ${LABELSIZE} 'CPU Cores'`${cpu_cores} cores"                                     "`label ${LABELSIZE} 'Used Memory'`${mem_used} / ${mem_total} MB"
pdline  $BOXSIZE "`label ${LABELSIZE} 'CPU Cores'`${cpu_threads} threads"                                 "`label ${LABELSIZE} 'Cached Memory'`${mem_cache} MB"
pdline  $BOXSIZE "`label ${LABELSIZE} 'Frequency'`${cpu_freq} Mhz"                                        "`label ${LABELSIZE} 'SWAP Usage'`${swap_used} / ${swap_total} MB"
pdclose $BOXSIZE

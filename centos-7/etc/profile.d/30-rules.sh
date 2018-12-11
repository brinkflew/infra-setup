#!/bin/bash

# ==============================================================================
#  Centos 7 Server MOTD Rules
# ==============================================================================
#  Outputs the rules which apply on the server.
#
#  Version: ... 0.0.1
#  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>
#  Created: ... Sat 24th, Nov. 2018 by Antoine Van Serveyt
#  License: ... MIT License
#  Updated: ...
# ==============================================================================

# # Prompt colors constants
# readonly NORM="\033[0m"
# readonly BOLD="\033[1m"
# readonly GREY="\033[38;5;242m"
# readonly ACCT="\033[38;5;{{accentcolor}}m"
# readonly WHIT="\033[38;5;255m"
#
# # Message boxes size
# readonly BOXSIZE=80

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
  cstr=`echo "$2" | sed -E 's/\\\e\[([[:digit:]]{1,3};?){1,3}m//g'`
  if [[ "$3" -eq "center" ]]; then
    pad=`repeat " " $((($1-4-${#cstr}) / 2))`
  fi
  echo -e "${GREY}║${NORM} ${pad}$2${pad} ${GREY}║${NORM}"
}

# Prints the title line of a box
ptitle() {
  cstr=`echo "$2" | sed -E 's/\\\e\[([[:digit:]]{1,3};?){1,3}m//g'`
  echo -e "${GREY}  ╔═`repeat '═' ${#cstr}`═╗${NORM}"
  echo -e "${GREY}╔═╣${NORM} ${2} ${GREY}╠`repeat '═' $1-8-${#cstr}`═╗${NORM}"
  echo -e "${GREY}║ ╚═`repeat '═' ${#cstr}`═╝`repeat " " $1-8-${#cstr}` ║${NORM}"
  pline $1
}

# Prints the closing line of a box
pclose() {
  echo -e "${GREY}╚`repeat '═' $1-2`╝${NORM}"
}

# ==============================================================================
#  The actual script starts here
# ==============================================================================

# Print the message box to the console
ptitle $BOXSIZE "${ACCT}Server Rules"
pline  $BOXSIZE "This is a private system that you are not to give out access to anyone" center
pline  $BOXSIZE "without permission from the admin. Do not store any illegal file nor" center
pline  $BOXSIZE "perform any illegal activity.  Stay in your home directory, keep" center
pline  $BOXSIZE "the system clean and make regular backups." center
pline  $BOXSIZE
pline  $BOXSIZE "Idle users will be removed after 15 minutes." center
pline  $BOXSIZE
pline  $BOXSIZE "${BOLD}DO NOT KEEP SENSITIVE LOGS OR HISTORY ON THIS SERVER${NORM}" center
pclose $BOXSIZE
echo

#!/bin/bash

# ==============================================================================
#  Centos 7 Server MOTD Greetings
# ==============================================================================
#  Provides guidance on what actions should be taken upon first login of a user.
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

# ==============================================================================
#  The actual script starts here
# ==============================================================================

# Print the message box to the console
ptitle $BOXSIZE "${ACCT}First Login?"
pline  $BOXSIZE "Please go to your home directory and run the post installation script and"
pline  $BOXSIZE "provide a value to the following required arguments:"
pline  $BOXSIZE "  - The MAC address of the interface in the MANAGEMENT network"
pline  $BOXSIZE "  - The IP address of the interface in the MANAGEMENT network"
pline  $BOXSIZE "  - The IP mask of the interface in the MANAGEMENT network"
pline  $BOXSIZE "  - The MAC address of the interface in the INTERNAL network"
pline  $BOXSIZE "  - The IP address of the interface in the INTERNAL network"
pline  $BOXSIZE "  - The IP mask of the interface in the INTERNAL network"
pclose $BOXSIZE

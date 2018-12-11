#!/bin/bash

# ==============================================================================
#  Centos 7 Server Installation Script
# ==============================================================================
#  For building, preparing and configuring newly installed servers.
#  This script is intended to apply last touches to the operating system
#  configuration.
#
#  Version: ... 0.0.1
#  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>
#  Created: ... Sun 25th, Nov. 2018 by Antoine Van Serveyt
#  License: ... MIT License
#  Updated: ...
# ==============================================================================

# Prompt colors constants
# readonly NORM="\033[0m"
# readonly GREY="\033[38;5;242m"
# readonly ERROR="\033[38;5;196m"
# readonly WARN="\033[38;5;214m"
# readonly OKAY="\033[38;5;034m"
# readonly INFO="$NORM"

# ==============================================================================
#  Functions are defined here to speed up the writing of the rest of the script
# ==============================================================================

# Prints a message to the console, prefixed by an information box
prompt() {
  echo "${GREY}[ ${1}${GREY} ]${NORM} ${2}"
}

# Prints an error message to the console and exits the script
error() {
  prompt "${ERROR}ERROR" "$1"
  exit 1
}

# Prints a warning message to the console
warn() {
  prompt "${WARN}WARN" "$1"
}

# Prints an okay message to the console
okay() {
  prompt "${OKAY}OKAY" "$1"
}

# Prints an informational message to the console
info() {
  prompt "${INFO}INFO" "$1"
}

# Check for a required value when an argument is passed to the script
arg_value_required() {
  if [ -z "$1" ]; then
    error "Argument ${2} requires a value"
  fi
}

# Prints help to the console
print_help() {
  echo ""
  echo " =============================================================================="
  echo "  Centos 7 Server Installation Script"
  echo " =============================================================================="
  echo "  For building, preparing and configuring newly installed servers."
  echo "  This script is intended to apply last touches to the operating system"
  echo "  configuration."
  echo ""
  echo "  Version: ... 0.0.1"
  echo "  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>"
  echo "  Created: ... Sun 25th, Nov. 2018 by Antoine Van Serveyt"
  echo "  License: ... MIT License"
  echo "  Updated: ..."
  echo " =============================================================================="
  echo ""
  echo " =============================================================================="
  echo "  Available arguments are:"
  echo " =============================================================================="
  # echo "  -u | --user    <username>    Username for the administrator user to create."
  # echo "                                 Type: String"
  # echo "                                 Default value: \"${username}\""
  # echo "  -p | --pass    <password>    Password for the administrator user to create."
  # echo "                                 Type: String"
  # echo "                                 Default value: \"${userpass}\""
  # echo "  -c | --color   <colorcode>   Custom color to use globally on the system."
  # echo "                                 Type: Integer between 0 and 255"
  # echo "                                 Default value: ${termcolor}"
  # echo "  -i | --install <packages>    Additional packages to install on the system."
  # echo "                                 Type: List of space-separated strings"
  # echo "                                 Default value: \"${additional_packages}\""
  echo "  -h | --help                 Print this help message."
  echo " =============================================================================="
  echo ""
  exit 0
}

# ==============================================================================
#  Reading arguments from the command line if necessary
# ==============================================================================

# Initializing
info "Initializing the installation script..."

# Get values from the command line
while [ "$#" -gt 0 ]; do
  case "$1" in
    # -u|--user)
    #   arg_value_required "$2" "$1"
    #   username="$2"
    #   ;;
    # -p|--pass)
    #   arg_value_required "$2" "$1"
    #   userpass="$2"
    #   ;;
    # -c|--color)
    #   arg_value_required "$2" "$1"
    #   termcolor="\e\[38;5;${2}m"
    #   ;;
    -h|--help)
      print_help
      ;;
    # -i|--install)
    #   arg_value_required "$2" "$1"
    #   additional_packages="$2"
    #   ;;
    *)
      error "Unrecognized argument ${1}"
      ;;
  esac
  shift 2
done

# Initialized
okay "Script initialized."

# ==============================================================================
#  The actual script starts here
# ==============================================================================

# Let's get started!
info "Running Centos 7 install script"

# Remove the firstlogin script from the MOTD
info "Removing firstlogin from MOTD"
rm -f /etc/profile.d/99-firstlogin.sh
okay "Removed firstlogin from MOTD"

# Remove root from the users allowed to login
info "Removing root from authorized users"
usermod -s /bin/false root
okay "Removed root from authorized users"

# Exit the installation script
okay "Done, enjoy your brand new Centos 7 system!"
exit 0

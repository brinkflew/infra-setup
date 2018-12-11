#!/bin/bash

# ==============================================================================
#  Centos 7 Server Installation Script
# ==============================================================================
#  For building, preparing and configuring newly installed servers.
#  This script is designed to be non-interactive after command-line arguments
#  have been passed, this ensures that the script can be safely run during
#  automatic deployment of servers.
#
#  Version: ... 0.0.1
#  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>
#  Created: ... Mon 19th, Nov. 2018 by Antoine Van Serveyt
#  License: ... MIT License
#  Updated: ...
# ==============================================================================

# Prompt colors constants
readonly NORM="\033[0m"
readonly GREY="\033[38;5;242m"
readonly ERROR="\033[38;5;196m"
readonly WARN="\033[38;5;214m"
readonly OKAY="\033[38;5;034m"
readonly INFO="$NORM"

# Default values if no args are specified while running this script
username="avanserv"           # Name of the admin user to create
userpass='$6$SmOYeHIB$08oJPqDlO5vd0CeSBD8vBqJIc8xJGDtHPJWNNyIYCXk/P/LbkESgL3070niNs56wK5cWhUPDxujUreTCecCIA.'   # Password for the user to create
termcolor="162"               # Color to use in custom outputs
additional_packages=""        # Additional packages to install by default

# Packages to install
readonly PACKAGES="sudo git"

# ==============================================================================
#  Functions are defined here to speed up the writing of the rest of the script
# ==============================================================================

# Prints a message to the console, prefixed by an information box
prompt() {
  echo -e "${GREY}[ ${1}${GREY} ]${NORM} ${2}"
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
  echo "  This script is designed to be non-interactive after command-line arguments"
  echo "  have been passed, this ensures that the script can be safely run during"
  echo "  automatic deployment of servers."
  echo ""
  echo "  Version: ... 0.0.1"
  echo "  Author: .... Antoine Van Serveyt <antoine.van.serveyt@avanserv.com>"
  echo "  Created: ... Mon 19th, Nov. 2018 by Antoine Van Serveyt"
  echo "  License: ... MIT License"
  echo "  Updated: ..."
  echo " =============================================================================="
  echo ""
  echo " =============================================================================="
  echo "  Available arguments are:"
  echo " =============================================================================="
  echo "  -u | --user    <username>    Username for the administrator user to create."
  echo "                                 Type: String"
  echo "                                 Default value: \"${username}\""
  echo "  -p | --pass    <password>    Password for the administrator user to create."
  echo "                                 Type: String"
  echo "                                 Default value: \"${userpass}\""
  echo "  -c | --color   <colorcode>   Custom color to use globally on the system."
  echo "                                 Type: Integer between 0 and 255"
  echo "                                 Default value: ${termcolor}"
  echo "  -i | --install <packages>    Additional packages to install on the system."
  echo "                                 Type: List of space-separated strings"
  echo "                                 Default value: \"${additional_packages}\""
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
    -u|--user)
      arg_value_required "$2" "$1"
      username="$2"
      ;;
    -p|--pass)
      arg_value_required "$2" "$1"
      userpass="$2"
      ;;
    -c|--color)
      arg_value_required "$2" "$1"
      termcolor="\e\[38;5;${2}m"
      ;;
    -h|--help)
      print_help
      ;;
    -i|--install)
      arg_value_required "$2" "$1"
      additional_packages="$2"
      ;;
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

# info "Running Centos 7 install script"
#
# # Update the freshly installed system
# info "Updating all installed packages..."
# yum -y update
# if [ "$?" -eq 0 ]; then
#   okay "All packages were successfully updated"
# else
#   error "Could not update system"
# fi
#
# # Install required and additional packages
# yum -y install $PACKAGES $additional_packages
# if [ "$?" -eq 0 ]; then
#   okay "successfully installed the following packages:"
#   echo "\"${PACKAGES} ${additional_packages}\""
# else
#   error "Could not install the selected packages"
# fi

# Setup the correct time-zone
# ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

# Update the skel directory
info "Updating the skel directory"
sed -i "s/{{accentcolor}}/${termcolor}/" ./etc/skel/.bashrc && \
cp ./etc/skel/.bashrc /etc/skel/.bashrc && \
cp ./etc/skel/.bashrc /home/avanserv/.bashrc && \
chmod 655 /etc/skel/.bashrc && chown root:root /etc/skel/.bashrc &&\
chmod 655 /home/avanserv/.bashrc && chown root:root /home/avanserv/.bashrc
okay "Updated the skel directory"

# Setup the SSHD configuration
info "Updating the SSHD configuration"
cp ./etc/ssh/sshd_config /etc/ssh/sshd_config && \
chown root:root /etc/ssh/sshd_config && \
chmod 600 /etc/ssh/sshd_config && \
sed -i "s/DefaultUserToBeOverriden/$username/" /etc/ssh/sshd_config
okay "Updated the SSHD configuration"

# Install the SSH banner
info "Installing the SSH banner"
cp ./etc/issue.net /etc/issue.net && \
chown root:root /etc/issue.net && \
chmod 644 /etc/issue.net
okay "Installed the SSH banner"

# Restart the SSH daemon to ensure the new configuration is applied
info "Restarting the SSH daemon"
systemctl restart sshd
okay "Successfully restarted the SSH daemon"

# Update the dynamic message of the day (MOTD)
info "Updating the Message of the Day"
cp ./etc/profile.d/00-colors.sh /etc/profile.d/ && \
sed -i "s/{{accentcolor}}/$termcolor/" /etc/profile.d/10-greetings.sh
cp ./etc/profile.d/10-greetings.sh /etc/profile.d/ && \
sed -i "s/{{accentcolor}}/$termcolor/" /etc/profile.d/10-greetings.sh
cp ./etc/profile.d/20-sysinfo.sh /etc/profile.d/ && \
sed -i "s/{{accentcolor}}/$termcolor/" /etc/profile.d/20-sysinfo.sh
cp ./etc/profile.d/30-rules.sh /etc/profile.d/ && \
sed -i "s/{{accentcolor}}/$termcolor/" /etc/profile.d/30-rules.sh
cp ./etc/profile.d/99-firstlogin.sh /etc/profile.d/ && \
sed -i "s/{{accentcolor}}/$termcolor/" /etc/profile.d/99-firstlogin.sh && \
chmod go+r /etc/profile.d/*.sh
okay "Updated the message of the day"

# Create the new administrative user
# info "Creating the new user '$username'"
# useradd -G wheel -m -s /bin/bash $username -p $userpass
# echo "$username:$userpass" | chpasswd
# chage -d 0 $username
# okay "Created the new user '$username'"

# Move the pre-installed SSH key to the newly created user's folder
# info "Setting up SSH for '$username'"
# mkdir -p /home/$username/.ssh && \
# mv /root/.ssh/authorized_keys /home/$username/.ssh/authorized_keys && \
# rm -Rf /root/.ssh && \
# chown $username:$username /home/$username/.ssh && \
# chown $username:$username /home/$username/.ssh/authorized_keys && \
# chmod 700 /home/$username/.ssh && \
# chmod 644 /home/$username/.ssh/authorized_keys
# okay "Set up SSH for '$username'"

# Configure Hosts files
# info "Updating hosts.allow and hosts.deny"
# echo "sshd: ALL" | tee -a /etc/hosts.allow
# echo "ALL: ALL" | tee -a /etc/hosts.deny
# okay "Updated hosts.allow and hosts.deny"

# Move the post-install folder
# mkdir -p /home/$username/postinstall && \
# cp -r ./postinstall /home/$username/postinstall && \
# chown -R root:root /home/$username/postinstall/* /home/$username/postinstall/**/* && \
# chmod u+x /home/$username/postinstall/run.sh

# Exit the installation script
okay "Done, enjoy your brand new Centos 7 system!"
exit 0

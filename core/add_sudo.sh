#!/bin/bash

# This script must be run as root (or with sudo)
####################################
# COMMAND TO USE
# chmod +x add_sudo.sh
# sudo ./add_sudo.sh some_other_user
####################################
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Check if a username was provided as an argument
if [ -z "$1" ]; then
  echo "Error: You must provide a username."
  echo "Usage: sudo $0 <username_to_add>"
  exit 1
fi

USERNAME=$1

# Check if the user exists
if ! id "$USERNAME" &>/dev/null; then
    echo "Error: User '$USERNAME' does not exist."
    exit 1
fi

# Add the user to the 'sudo' group
echo "Adding user '$USERNAME' to the 'sudo' group..."
usermod -aG sudo $USERNAME

if [ $? -eq 0 ]; then
  echo "Successfully added '$USERNAME' to the 'sudo' group."
  echo "The user must log out and log back in for this change to take effect."
else
  echo "An error occurred while trying to add the user to the 'sudo' group."
fi
#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- 1. Update Package Manager ---
echo "Updating package list..."
apt-get update

# --- 2. Install Prerequisites ---
echo "Installing prerequisites..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg

# --- 3. Add Docker's Official GPG Key ---
echo "Adding Docker's GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# --- 4. Set Up Docker Repository ---
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- 5. Install Docker Engine ---
echo "Updating package list again and installing Docker..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 6. Add Current User to Docker Group ---
# This adds the user who is *running* the script with sudo,
# or you can replace '$SUDO_USER' with a specific username.
if [ -n "$SUDO_USER" ]; then
    echo "Adding user '$SUDO_USER' to the 'docker' group..."
    usermod -aG docker $SUDO_USER
    echo "Successfully added '$SUDO_USER' to the docker group."
else
    echo "Could not determine user to add to docker group. Please run:"
    echo "sudo usermod -aG docker \$USER"
    echo "Then log out and log back in."
fi

# --- 7. Final Message ---
echo ""
echo "Docker installation complete."
echo "****************************************************************"
echo "** IMPORTANT: You must log out and log back in for the group **"
echo "** changes to take effect and to run docker without sudo.     **"
echo "****************************************************************"
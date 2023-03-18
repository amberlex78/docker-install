#!/bin/bash

#############################################################################
# Install Docker on Linux Mint 20
#
# https://github.com/amberlex78/docker-install
#############################################################################

echo ;
echo "01------------ Update the APT packages indexes"
sudo apt update


echo ;
echo "02------------ Uninstall old versions"
sudo sudo systemctl stop docker.socket
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo apt update


echo ;
echo "03------------ Check packages"
packages="ca-certificates curl gnupg lsb-release"
for package in $packages
do
    cmd=$(dpkg -s $package 2>/dev/null | grep "ok installed")
    if [ $? == 0 ]
        then
            echo "$package INSTALLED."
        else
            echo "$package NOT INSTALLED. Installing..."
            sudo apt install -y $package
    fi
done


echo ;
echo "04------------ Add docker GPG key"
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo ;
echo "05------------ Add docker deb for Ubuntu Focal 20.04 (Mint 20.x)"
if [ -a /etc/apt/sources.list.d/docker.list ]
    then
        echo "The deb package is already exists."
    else
        # See PACKAGE BASE in https://linuxmint.com/download_all.php
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi


echo ;
echo "06------------ Install Docker"
cmd=$(dpkg -s docker-ce 2>/dev/null | grep "ok installed")
if [ $? == 0 ]
    then
        echo "The 'docker-ce' is already exists."
    else
        echo "The 'docker-ce' NOT INSTALLED. Installing..."
        sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi


echo ;
echo "07------------ Add group 'docker'"
group=$(getent group docker | grep "docker")
if [ $? == 0 ]
    then
        echo "The group 'docker' is already exists."
    else
        sudo groupadd docker
        echo "The group 'docker' was added."
fi


echo ;
echo "08------------ Add user '$USER' to the 'docker' group"
user_group=$(groups $USER | grep "docker")
if [ $? == 0 ]
    then
        echo "The user '$USER' is already in 'docker' group."
    else
        sudo usermod -aG docker $USER
        echo "User '$USER' was added to 'docker' group."
fi


echo ;
echo "09------------ Check versions"
docker -v
docker compose version


echo ;
echo "10------------ docker run hello-world"
docker run hello-world


echo ;
exit 0

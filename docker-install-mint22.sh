#!/bin/bash

#############################################################################
# Install Docker on Linux Mint 22
#
# https://github.com/amberlex78/docker-install
#############################################################################

echo ;
echo "01------------ Update the APT packages indexes"
sudo apt update


echo ;
echo "02------------ Uninstall old versions"
sudo sudo systemctl stop docker.socket


echo "02.0---------- Uninstall all conflicting packages"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt remove $pkg; done

echo "02.1---------- Uninstall the Docker Engine, CLI, containerd, and Docker Compose packages"
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo apt update

echo ;
echo "02.2---------- Delete all images, containers, and volumes"
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

echo ;
echo "02.3---------- Remove source list and keyrings"
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /etc/apt/keyrings/docker.asc


echo ;
echo "03------------ Check packages"
packages="ca-certificates curl"
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
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


echo ;
echo "05------------ Add docker deb for Ubuntu Noble Numbat 24.04 (Mint 22.x)"
if [ -a /etc/apt/sources.list.d/docker.list ]
    then
        echo "The deb package is already exists."
    else
        # See PACKAGE BASE in https://linuxmint.com/download_all.php
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
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

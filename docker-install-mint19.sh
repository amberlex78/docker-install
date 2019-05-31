#!/bin/bash

#############################################################################
# Install Docker on Linux Mint 19
#
# https://github.com/amberlex78/docker-install
#############################################################################

echo ;
echo "------------ Update the APT packages indexes"
sudo apt-get update

echo ;
echo "------------ Uninstall old versions"
sudo apt-get remove docker docker-engine docker.io containerd run
sudo apt-get update

echo ;
echo "------------ Check packages"
packages="apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
for package in $packages
do
    cmd=$(dpkg -s $package 2>/dev/null | grep "ok installed")
    if [ $? == 0 ]
        then
            echo "$package INSTALLED."
        else
            echo "$package NOT INSTALLED. Installing..."
            sudo apt-get install -y $package
    fi
done


echo ;
echo "------------ Add docker GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


echo ;
echo "------------ Verify fingerprint"
sudo apt-key fingerprint 0EBFCD88


echo ;
echo "------------ Add docker deb for 19.1"
if [ -a /etc/apt/sources.list.d/docker.list ]
    then
        echo "The deb package is already exists."
    else
        echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu    bionic    stable" | sudo tee /etc/apt/sources.list.d/docker.list
fi


echo ;
echo "------------ Install Docker"
cmd=$(dpkg -s docker-ce 2>/dev/null | grep "ok installed")
if [ $? == 0 ]
    then
        echo "The 'docker-ce' is already exists."
    else
        echo "The 'docker-ce' NOT INSTALLED. Installing..."
        sudo apt-get update && sudo apt-get install docker-ce
fi


echo ;
echo "------------ install Docker Compose";
if [ -a /usr/local/bin/docker-compose ]
    then
        echo "The 'docker-compose' is already exists."
    else
        # Releases: https://github.com/docker/compose/releases
        sudo curl \
            -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m) \
            -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
fi


echo ;
echo "------------ Add group 'docker'"
group=$(getent group docker | grep "docker")
if [ $? == 0 ]
    then
        echo "The group 'docker' is already exists."
    else
        sudo groupadd docker
        echo "The group 'docker' was added."
fi


echo ;
echo "------------ Add user '$USER' to the 'docker' group"
user_group=$(groups $USER | grep "docker")
if [ $? == 0 ]
    then
        echo "The user '$USER' is already in 'docker' group."
    else
        sudo usermod -aG docker $USER
        echo "User '$USER' was added to 'docker' group."
fi


echo ;
echo "------------ Check versions"
docker -v
docker-compose -v


echo ;
exit 0

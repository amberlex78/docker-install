#!/bin/bash

#############################################################################
# Install Docker on Linux Mint 22 / Ubuntu 24.04
#
# Optimized with official DEB822 format and universal OS codename fallback
#############################################################################

echo ;
echo "01------------ Update the APT packages indexes"
sudo apt-get update

echo ;
echo "02------------ Uninstall old versions"
sudo systemctl stop docker.socket 2>/dev/null || true

echo "02.0---------- Uninstall all conflicting packages"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

echo "02.1---------- Uninstall the Docker Engine, CLI, containerd, and Docker Compose packages"
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

echo ;
echo "02.2---------- Delete all images, containers, and volumes"
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

echo ;
echo "02.3---------- Remove old source lists and keyrings"
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/docker.sources
sudo rm -f /etc/apt/keyrings/docker.asc

echo ;
echo "03------------ Check and install prerequisites"
packages="ca-certificates curl"
for package in $packages
do
    dpkg -s $package 2>/dev/null | grep -q "ok installed"
    if [ $? -eq 0 ]
        then
            echo "$package INSTALLED."
        else
            echo "$package NOT INSTALLED. Installing..."
            sudo apt-get install -y $package
    fi
done

echo ;
echo "04------------ Add Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "GPG key added."

echo ;
echo "05------------ Add the repository to Apt sources (DEB822 format)"
if [ -f /etc/apt/sources.list.d/docker.sources ]
    then
        echo "The docker.sources file already exists."
    else
        sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
        echo "Repository added."
        sudo apt-get update
fi

echo ;
echo "06------------ Install Docker Engine"
dpkg -s docker-ce 2>/dev/null | grep -q "ok installed"
if [ $? -eq 0 ]
    then
        echo "The 'docker-ce' is already installed."
    else
        echo "The 'docker-ce' NOT INSTALLED. Installing..."
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo ;
echo "07------------ Add group 'docker'"
if getent group docker > /dev/null
    then
        echo "The group 'docker' already exists."
    else
        sudo groupadd docker
        echo "The group 'docker' was added."
fi

echo ;
echo "08------------ Add user '$USER' to the 'docker' group"
if groups $USER | grep -q "\bdocker\b"
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
echo "10------------ Verify installation"
echo "Запускаємо тестовий контейнер через sudo (бо зміна груп діє після перезаходу)"
sudo docker run hello-world

echo ;
echo "======================================================================"
echo "ГОТОВО! Щоб керувати Docker без 'sudo', ВАМ ТРЕБА ПЕРЕЗАВАНТАЖИТИ ПК АБО ВИЙТИ І ЗАЙТИ В СИСТЕМУ (Log out / Log in)."
echo "======================================================================"
exit 0
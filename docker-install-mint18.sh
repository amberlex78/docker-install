#############################################################################
# Install Docker on Linux Mint 18
#
# https://github.com/amberlex78/docker-install
#############################################################################

echo ;
echo "------------ Update the APT packages indexes"
sudo apt-get update


echo ;
echo "------------ Check packages"
packages="apt-transport-https ca-certificates curl mintsources"
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
echo "------------ Install extra packages"
sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual


echo ;
echo "------------ Add docker GPG key"
sudo apt-key adv \
    --keyserver hkp://p80.pool.sks-keyservers.net:80 \
    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D


echo ;
echo "------------ Add docker deb for 16.04"
if [ -a /etc/apt/sources.list.d/docker.list ]
    then
        echo "The deb package is already exists."
    else
        echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
fi


echo ;
echo "------------ Install Docker"
cmd=$(dpkg -s docker-engine 2>/dev/null | grep "ok installed")
if [ $? == 0 ]
    then
        echo "The 'docker-engine' is already exists."
    else
        echo "The 'docker-engine' NOT INSTALLED. Installing..."
        sudo apt-get install -y docker-engine
fi


echo ;
echo "------------ install Docker Compose";
if [ -a /usr/local/bin/docker-compose ]
    then
        echo "The 'docker-compose' is already exists."
    else
        # Releases: https://github.com/docker/compose/releases
        sudo curl \
            -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) \
            -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
fi


echo ;
echo "------------ Check versions"
docker -v
docker-compose -v


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
exit 0
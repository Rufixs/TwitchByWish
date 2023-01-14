#!/bin/bash


# Install sudo and add me to the group

apt install sudo
usermod -aG sudo eliet

# Create user oscar

sudo useradd oscar
sudo echo LIv3! | passwd theUsername --stdin
sudo usermod -aG sudo oscar

# Install ssh

apt install openssh-server
systemctl restart sshd

# Install Docker !

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update


# Install docker rtmp


if ! command -v docker > /dev/null; then
  echo "Docker is not installed. Please install Docker and run the script again."
  exit 1
fi


docker pull jasonrivers/nginx-rtmp-hls

docker run -d -p 1935:1935 -p 8080:80 --name rtmp-to-hls jasonrivers/nginx-rtmp-hls

echo "RTMP to HLS conversion container is running. You can now send an RTMP stream to rtmp://localhost:1935/live and access the HLS stream at http://localhost:8080/live/stream.m3u8"

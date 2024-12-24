#!/bin/bash

sudo apt-get update -y
sudo apt-get install nfs-common -y
echo $1
ls -la
pwd
sudo mkdir -p mount-ecs
ls -la
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $1:/ mount-ecs
sudo mkdir -p mount-ecs/nginx/config
sudo mkdir -p mount-ecs/nginx/html

sudo chmod -R 777 mount-ecs/nginx/

sudo chown -R ubuntu.ubuntu mount-ecs



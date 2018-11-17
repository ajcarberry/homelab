#!/bin/bash

##Create and power up Alfred
adduser alfred
mkdir -p /home/alfred/.ssh
touch /home/alfred/.ssh/authorized_keys
curl -L 'https://github.com/ajcarberry/homelab/blob/master/general/baseImages/ssh/alfred.pub' -o /home/alfred/.ssh/authorized_keys
chmod 700 /home/alfred/.ssh
chmod 600 /home/alfred/.ssh/authorized_keys
chown -R alfred:alfred /home/alfred/.ssh
echo "alfred ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/alfred
chmod 440 /etc/sudoers.d/alfred
chown root:root /etc/sudoers.d/alfred

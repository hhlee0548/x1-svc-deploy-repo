#!/bin/bash

sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

sudo apt-get install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install pyopenssl
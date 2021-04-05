#!/bin/bash

pwd=$PWD

sudo apt update  
sudo apt install --no-install-recommends -y cmake g++ libmuparser-dev libqt5charts5-dev
libqalculate-dev libqt5svg5-dev libqt5x11extras5-dev python3-dev qtbase5-dev qtdeclarative5-dev
unzip virtualbox wget libqt5sql5-sqlite

# git clone https://github.com/albertlauncher/albert.git
git clone -b wayland-crash-fix https://github.com/johanhelsing/albert/ wayland-crash-fix  
# cd $pwd/albert
cd $pwd/wayland-crash-fix  
git clone https://github.com/albertlauncher/plugins.git  
# cd $pwd/albert/plugins/python
cd $pwd/wayland-crash-fix/plugins/python  
git clone https://github.com/pybind/pybind11.git  
mkdir $pwd/albert-build  
cd $pwd/albert-build  
# cmake ../albert -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
cmake ../wayland-crash-fix -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug  
make  
sudo make install  

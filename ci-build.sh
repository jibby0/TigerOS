#!/bin/bash
set -eu

#####################################################################
# TigerOS Build Script for running on the build box with Jenkins CI #
# @author: Aidan Kahrs	                                            #
#                                                                   #
# Usage: sudo bash ci-build.sh				                        #
#                                                                   #
#####################################################################
# Check that the current user is root
if [ $EUID != 0 ]
then
    echo "Please run this script as root (sudo $@$0)."
    exit
fi
setenforce 0
rm -rf tigeros.ks
wget -O tigeros.ks https://raw.githubusercontent.com/RITlug/TigerOS/master/tigeros.ks
livemedia-creator --ks tigeros.ks --no-virt --resultdir /var/lmc --project TigerOS-Live --make-iso --volid TigerOS --iso-only --iso-name TigerOS.iso --releasever 25 --title TigerOS-live --macboot
cp -f /var/lmc/TigerOS.iso /srv/isos/TigerOS-$(date +%Y%d%m) 
rm -rf /var/lmc/
cd /srv/isos
sha512sum *.iso > CHECKSUM512-$(date +%Y%d%m) 
chown -R nginx:nginx /srv
chmod 755 /srv/isos/*.iso
cd /home/build
rm -rf anaconda/ *.log livemedia.log program.log
setenforce 1

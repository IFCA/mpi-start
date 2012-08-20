#!/bin/sh
# installation script for WN on sl5 + emi2 

################
# REPO CONFIG  #
################

echo "*"
echo "* Repository Configuration"
echo "*"

#echo "** Epel"
#wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
#yum -q -y localinstall epel-release-6-5.noarch.rpm
#if [ $? -ne 0 ] ; then exit 1; fi

#echo "** Trust Anchors"
#wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo -O /etc/yum.repos.d/egi-trust.repo

echo "** emi 2"
wget --no-check-certificate  https://twiki.cern.ch/twiki/pub/EMI/EMI-2/emi-2-rc4-sl6.repo -O /etc/yum.repos.d/emi2.repo
if [ $? -ne 0 ] ; then exit 1; fi

## update 
echo "** YUM Update + install CAs"
yum -q -y update
yum -q -y install ca-policy-egi-core
if [ $? -ne 0 ] ; then exit 1; fi

echo "******************************************************"
echo " REPO CONFIG OK!"
echo "******************************************************"
exit 0